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
        case deadlineSelected(Date)
        case submit(info: RegisterInfoView.Draft, memberPrices: [Int: Int])
        case setMembers([String])

        // TODO: - 상품 등록 화면 다른 액션
    }


    // MARK: - Output

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let requestPicker: AnyPublisher<Int, Never>
        let deadline: AnyPublisher<Date?, Never>
        let fieldErrors: AnyPublisher<FieldErrors, Never>

        // TODO: - 상품 등록 화면 다른 Output
    }

    let output: Output


    // MARK: - Properties

    private let maxCount: Int

    private let imagesSubject = CurrentValueSubject<[UIImage], Never>([])
    private let requestPickerSubject = PassthroughSubject<Int, Never>()
    private let deadlineSubject = CurrentValueSubject<Date?, Never>(nil)
    private let membersSubject = CurrentValueSubject<[String], Never>([])
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

    init(maxCount: Int = 5) {
        self.maxCount = maxCount
        self.output = Output(
            images: imagesSubject.eraseToAnyPublisher(),
            requestPicker: requestPickerSubject.eraseToAnyPublisher(),
            deadline: deadlineSubject.eraseToAnyPublisher(),
            fieldErrors: fieldErrorsSubject.eraseToAnyPublisher()
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
            
        case .deadlineSelected(let date):
            deadlineSubject.send(date)
            
        case .setMembers(let members):
            membersSubject.send(members)
            if !members.isEmpty {
                hasEverHadMembers = true
            }
            
        case .submit(let info, let memberPrices):
            var errors = FieldErrors.empty

            if imagesSubject.value.isEmpty {
                errors.images = "사진을 1장 이상 등록해주세요"
            }

            if info.artist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
            // 에러가 있으면 여기서 종료 (성공 케이스에서 UseCase 호출)
            // TODO: presignedURL 업로드 + 상품 등록 UseCase 호출
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
