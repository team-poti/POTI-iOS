//
//  UploadPostImagesUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

protocol UploadPostImagesUseCase {
    func execute(images: [UploadImageEntity]) async throws -> [String]
}

final class DefaultUploadPostImagesUseCase: UploadPostImagesUseCase {
    private let repository: ImageUploadInterface

    init(repository: ImageUploadInterface) {
        self.repository = repository
    }

    func execute(images: [UploadImageEntity]) async throws -> [String] {
        let presignedURLs = try await repository.fetchPresignedURLs(fileExtensions: images.map(\.fileExtension))
        var imageFileNames: [String] = []

        for (image, presignedURL) in zip(images, presignedURLs) {
            try await repository.uploadImage(data: image.data, to: presignedURL.uploadURL, mimeType: image.mimeType)
            imageFileNames.append(presignedURL.fileName)
        }
        return imageFileNames
    }
}
