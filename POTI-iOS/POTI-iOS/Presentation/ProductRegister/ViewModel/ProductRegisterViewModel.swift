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

        // TODO: - 상품 등록 화면 다른 액션
    }


    // MARK: - Output

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let requestPicker: AnyPublisher<Int, Never>

        // TODO: - 상품 등록 화면 다른 Output
    }

    let output: Output


    // MARK: - Properties

    private let maxCount: Int

    private let imagesSubject = CurrentValueSubject<[UIImage], Never>([])
    private let requestPickerSubject = PassthroughSubject<Int, Never>()


    // MARK: - Initializer

    init(maxCount: Int = 5) {
        self.maxCount = maxCount
        self.output = Output(
            images: imagesSubject.eraseToAnyPublisher(),
            requestPicker: requestPickerSubject.eraseToAnyPublisher()
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
