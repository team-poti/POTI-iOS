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
        case submit(
            info: RegisterInfoView.Draft,
            memberPrices: [Int: Int],
            shippings: [RegisterShippingView.ShippingRequest]
        )
        case setMembers([String?])
        case setArtist(RegisterArtistEntity)
        case fetchTitles(keyword: String)
        case fetchArtistsList(artistId: Int)
    }

    // MARK: - Output

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let requestPicker: AnyPublisher<Int, Never>
        let deadline: AnyPublisher<Date?, Never>
        let fieldErrors: AnyPublisher<FieldErrors, Never>
        let titleSuggestions: AnyPublisher<[String], Never>
        let titles: AnyPublisher<[String], Never>
        let members: AnyPublisher<[String], Never>
        let didRegister: AnyPublisher<Void, Never>
        let registerFailed: AnyPublisher<String, Never>
    }

    let output: Output

    // MARK: - Properties

    private let maxCount: Int

    private let registerTitlesUseCase: RegisterTitlesUseCase
    private let registerPostsUseCase: RegisterPostsUseCase
    private let imagesRepository: ImagesInterface
    private let artistsUseCase: ArtistsUsecase

    private let titlesSubject = CurrentValueSubject<[String], Never>([])
    private let imagesSubject = CurrentValueSubject<[UIImage], Never>([])
    private let requestPickerSubject = PassthroughSubject<Int, Never>()
    private let deadlineSubject = CurrentValueSubject<Date?, Never>(nil)
    private let membersSubject = CurrentValueSubject<[String], Never>([])
    private let selectedArtistSubject = CurrentValueSubject<RegisterArtistEntity?, Never>(nil)
    private var selectedArtist: RegisterArtistEntity?
    private var hasEverHadMembers: Bool = false
    private var originalMemberEntities: [MemberEntity] = []

    private let didRegisterSubject = PassthroughSubject<Void, Never>()
    private let registerFailedSubject = PassthroughSubject<String, Never>()

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
        registerPostsUseCase: RegisterPostsUseCase,
        imagesRepository: ImagesInterface,
        artistsUseCase: ArtistsUsecase
    ) {
        self.maxCount = maxCount
        self.registerTitlesUseCase = registerTitlesUseCase
        self.registerPostsUseCase = registerPostsUseCase
        self.imagesRepository = imagesRepository
        self.artistsUseCase = artistsUseCase

        self.output = Output(
            images: imagesSubject.eraseToAnyPublisher(),
            requestPicker: requestPickerSubject.eraseToAnyPublisher(),
            deadline: deadlineSubject.eraseToAnyPublisher(),
            fieldErrors: fieldErrorsSubject.eraseToAnyPublisher(),
            titleSuggestions: titlesSubject.eraseToAnyPublisher(),
            titles: titlesSubject.eraseToAnyPublisher(),
            members: membersSubject.eraseToAnyPublisher(),
            didRegister: didRegisterSubject.eraseToAnyPublisher(),
            registerFailed: registerFailedSubject.eraseToAnyPublisher()
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

            var errors = fieldErrorsSubject.value
            errors.artist = nil
            fieldErrorsSubject.send(errors)

            titlesSubject.send([])
            
        case .fetchTitles(let keyword):
            let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty else {
                titlesSubject.send([])
                return
            }

            guard let artistId = selectedArtist?.artistId ?? selectedArtistSubject.value?.artistId else {
                var errors = fieldErrorsSubject.value
                errors.artist = "아티스트를 먼저 선택해주세요"
                fieldErrorsSubject.send(errors)
                titlesSubject.send([])
                return
            }

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
                        self.titlesSubject.send(titles)
                    }
                } catch {
                    await MainActor.run {
                        self.titlesSubject.send([])
                    }
                }
            }
            
        case .submit(let info, let memberPrices, let shippings):
            var errors = FieldErrors.empty

            if imagesSubject.value.isEmpty {
                errors.images = "사진을 1장 이상 등록해주세요"
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

                    let imageDatas = self.imagesSubject.value.compactMap {
                        $0.jpegData(compressionQuality: 0.8)
                    }

                    let presigned = try await self.imagesRepository.fetchPresignedUrls(count: imageDatas.count)

                    // S3 업로드
                    var imageFileNames: [String] = []
                    for (data, item) in zip(imageDatas, presigned) {
                        try await self.imagesRepository.uploadImage(data: data, to: item.uploadUrl)
                        imageFileNames.append(item.fileName)
                    }

                    // 옵션(멤버 가격) 구성
                    let options: [RegisterRequestEntity.Option] = self.makeOptions(from: memberPrices)

                    // 배송 구성
                    let shippingEntities: [RegisterRequestEntity.Shipping] = shippings.map {
                        .init(deliveryMethodId: $0.deliveryMethodId, price: $0.price)
                    }

                    let entity = RegisterRequestEntity(
                        artistId: artistId,
                        title: info.productType,
                        content: info.description,
                        deadline: info.deadlineText,
                        bankName: info.bank,
                        accountNumber: info.accountNumber,
                        imageUrls: imageFileNames,
                        options: options,
                        shippings: shippingEntities
                    )

                    _ = try await self.registerPostsUseCase.execute(entity)

                    await MainActor.run {
                        self.didRegisterSubject.send(())
                    }
                } catch {
                    await MainActor.run {
                        self.registerFailedSubject.send("등록에 실패했어요")
                    }
                }
            }
            
        case .fetchArtistsList(let artistId):
            fetchMembers(artistId: artistId)
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
    // MARK: - Members Fetching

    private func fetchMembers(artistId: Int) {
        // Reset previous member state when artist changes
        membersSubject.send([])
        hasEverHadMembers = false
        originalMemberEntities = []

        Task { [weak self] in
            guard let self else { return }
            do {
                let entities = try await self.artistsUseCase.execute(artistId: artistId)

                let mappedMembers = entities.map { entity in
                    MemberEntity(
                        id: entity.artistId,
                        name: entity.artistName,
                        price: 0
                    )
                }

                let names = mappedMembers.map { $0.name }

                await MainActor.run {
                    self.originalMemberEntities = mappedMembers
                    self.hasEverHadMembers = !mappedMembers.isEmpty
                    self.membersSubject.send(names)
                }
            } catch {
                print("❌ fetchMembers error:", error)
            }
        }
    }

    // MARK: - Options Mapping

    /// memberPrices: [rowIndex: price]
    /// originalMemberEntities의 index와 row index가 1:1로 매칭된다는 가정
    private func makeOptions(from memberPrices: [Int: Int]) -> [RegisterRequestEntity.Option] {
        guard !memberPrices.isEmpty else { return [] }

        var options: [RegisterRequestEntity.Option] = []

        for (rowIndex, price) in memberPrices {
            guard originalMemberEntities.indices.contains(rowIndex) else { continue }
            let member = originalMemberEntities[rowIndex]
            options.append(.init(memberId: member.id, price: price))
        }

        // 안정적 결과를 위해 정렬
        options.sort { $0.memberId < $1.memberId }
        return options
    }
}
