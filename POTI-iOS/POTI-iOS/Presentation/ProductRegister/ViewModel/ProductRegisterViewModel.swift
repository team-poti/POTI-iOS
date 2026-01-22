//
//  ProductRegisterViewModel.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/16/26.
//

import UIKit

import Combine
import PhotosUI

final class ProductRegisterViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case tapAdd
        case tapDelete(Int)
        case didFinishPicking([PHPickerResult])
        case productTypeQueryChanged(artistId: Int, keyword: String)
        case deadlineSelected(Date)
        case submit(info: RegisterInfoView.Draft, memberPrices: [Int: Int])
        case setMembers([String?])
        case setArtist(RegisterArtistEntity)
        case fetchTitles(keyword: String)
    }

    // MARK: - Output

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let requestPicker: AnyPublisher<Int, Never>
        let deadline: AnyPublisher<Date?, Never>
        let fieldErrors: AnyPublisher<FieldErrors, Never>
        let titleSuggestions: AnyPublisher<[String], Never>
        let titles: AnyPublisher<[String], Never>
    }

    let output: Output

    // MARK: - Properties

    private let maxCount: Int

    private let registerTitlesUseCase: RegisterTitlesUseCase
    private let registerPostsUseCase: RegisterPostsUseCase

    private let titlesSubject = CurrentValueSubject<[String], Never>([])
    private let imagesSubject = CurrentValueSubject<[UIImage], Never>([])
    private let requestPickerSubject = PassthroughSubject<Int, Never>()
    private let deadlineSubject = CurrentValueSubject<Date?, Never>(nil)
    private let membersSubject = CurrentValueSubject<[String], Never>([])
    private let selectedArtistSubject = CurrentValueSubject<RegisterArtistEntity?, Never>(nil)
    private var selectedArtist: RegisterArtistEntity?
    private var hasEverHadMembers: Bool = false

    struct FieldErrors {
        var images: String?
        var artist: String?
        var productType: String?
        var deadline: String?
        var description: String?
        var accountNumber: String?
        var bank: String?
        var members: String?

        var hasError: Bool {
            return images != nil || artist != nil || productType != nil || deadline != nil || description != nil || accountNumber != nil || bank != nil || members != nil
        }

        static var empty: FieldErrors { .init() }
    }

    private let fieldErrorsSubject = CurrentValueSubject<FieldErrors, Never>(.empty)

    // MARK: - Initializer

    init(
        maxCount: Int = 5,
        registerTitlesUseCase: RegisterTitlesUseCase,
        registerPostsUseCase: RegisterPostsUseCase
    ) {
        self.maxCount = maxCount
        self.registerTitlesUseCase = registerTitlesUseCase
        self.registerPostsUseCase = registerPostsUseCase

        self.output = Output(
            images: imagesSubject.eraseToAnyPublisher(),
            requestPicker: requestPickerSubject.eraseToAnyPublisher(),
            deadline: deadlineSubject.eraseToAnyPublisher(),
            fieldErrors: fieldErrorsSubject.eraseToAnyPublisher(),
            titleSuggestions: titlesSubject.eraseToAnyPublisher(),
            titles: titlesSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {

        case .tapAdd:
            let remaining = maxCount - imagesSubject.value.count
            guard remaining > 0 else { return }
            requestPickerSubject.send(remaining)

        case .tapDelete(let index):
            var current = imagesSubject.value
            guard current.indices.contains(index) else { return }
            current.remove(at: index)
            imagesSubject.send(current)

        case .didFinishPicking(let results):
            guard !results.isEmpty else { return }

            let remaining = maxCount - imagesSubject.value.count
            guard remaining > 0 else { return }

            Task { [weak self] in
                guard let self else { return }

                let loadedImages = await self.loadImages(from: results)
                let trimmed = Array(loadedImages.prefix(remaining))

                await MainActor.run {
                    let merged = self.imagesSubject.value + trimmed
                    self.imagesSubject.send(merged)
                }
            }
            
        case .productTypeQueryChanged(_, let keyword):
            action(.fetchTitles(keyword: keyword))
            
        case .deadlineSelected(let date):
            deadlineSubject.send(date)
            
        case .setMembers(let members):
            let normalized = members.compactMap { $0 }
            membersSubject.send(normalized)
            if !normalized.isEmpty {
                hasEverHadMembers = true
            }
            
        case .setArtist(let artist):
            selectedArtist = artist
            selectedArtistSubject.send(artist)

            // 아티스트 선택되면 artist error 해제
            var errors = fieldErrorsSubject.value
            errors.artist = nil
            fieldErrorsSubject.send(errors)

            // 이전 검색 결과 초기화
            titlesSubject.send([])
            
        case .fetchTitles(let keyword):
            let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)

            // 입력이 비면 리스트 비움
            guard !trimmed.isEmpty else {
                titlesSubject.send([])
                return
            }

            // 아티스트 선택 안 된 상태에서 상품 종류 입력 -> artist 에러
            guard let artistId = selectedArtist?.artistId ?? selectedArtistSubject.value?.artistId else {
                var errors = fieldErrorsSubject.value
                errors.artist = "아티스트를 먼저 선택해주세요"
                fieldErrorsSubject.send(errors)
                titlesSubject.send([])
                return
            }

            // 아티스트가 선택되어 있으면 artist error는 해제
            var errors = fieldErrorsSubject.value
            errors.artist = nil
            fieldErrorsSubject.send(errors)

            Task { [weak self] in
                guard let self else { return }
                do {
                    let titles = try await self.registerTitlesUseCase.execute(
                        artistId: artistId,
                        keyword: trimmed
                    )
                    await MainActor.run {
                        self.titlesSubject.send(titles as! [String])
                    }
                } catch {
                    await MainActor.run {
                        self.titlesSubject.send([])
                    }
                }
            }
            
        case .submit(let info, let memberPrices):
            var errors = FieldErrors.empty

            if imagesSubject.value.isEmpty {
                errors.images = "사진을 1장 이상 등록해주세요"
            }

            if info.artist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.artist = "아티스트를 선택해주세요"
            }

            let selectedArtistId = info.artistId ?? selectedArtist?.artistId ?? selectedArtistSubject.value?.artistId
            if selectedArtistId == nil {
                errors.artist = "아티스트를 선택해주세요"
            }

            if info.productType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.productType = "상품 종류를 입력해주세요"
            }

            if info.deadlineText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.deadline = "모집 기한을 선택해주세요"
            }

            if info.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.description = "설명을 입력해주세요"
            }

            if info.accountNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.accountNumber = "계좌번호를 입력해주세요"
            }

            if info.bank.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.bank = "은행 정보를 입력해주세요"
            }

            if hasEverHadMembers {
                if membersSubject.value.isEmpty {
                    errors.members = "선택한 멤버가 없어요"
                } else {
                    let count = membersSubject.value.count
                    let hasMissingPrice = (0..<count).contains { memberPrices[$0] == nil }

                    if hasMissingPrice {
                        errors.members = "모든 멤버에 가격을 설정해주세요"
                    }
                }
            }

            fieldErrorsSubject.send(errors)

            guard !errors.hasError else { return }

            Task { [weak self] in
                guard let self else { return }
                do {
                    guard let artistId = info.artistId ?? self.selectedArtist?.artistId ?? self.selectedArtistSubject.value?.artistId else {
                        await MainActor.run {
                            var current = self.fieldErrorsSubject.value
                            current.artist = "아티스트를 선택해주세요"
                            self.fieldErrorsSubject.send(current)
                        }
                        return
                    }

                    let entity = RegisterRequestEntity(
                        artistId: artistId,
                        title: info.productType,
                        content: info.description,
                        deadline: info.deadlineText,
                        bankName: info.bank,
                        accountNumber: info.accountNumber,
                        imageUrls: [],
                        options: [],
                        shippings: []
                    )

                    _ = try await self.registerPostsUseCase.execute(entity)

                    // TODO: 성공 Output(예: 등록 완료 이벤트) 필요하면 publisher 추가
                } catch {
                    // TODO: 실패 Output(예: 토스트/에러 상태) 필요하면 publisher 추가
                }
            }
        }
    }

    // MARK: - Custom Method

    private func loadImages(from results: [PHPickerResult]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self) { group in
            for result in results {
                group.addTask {
                    await Self.loadImage(from: result)
                }
            }

            var images: [UIImage] = []
            for await image in group {
                if let image { images.append(image) }
            }
            return images
        }
    }

    private static func loadImage(from result: PHPickerResult) async -> UIImage? {
        await withCheckedContinuation { continuation in
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                continuation.resume(returning: object as? UIImage)
            }
        }
    }
}
