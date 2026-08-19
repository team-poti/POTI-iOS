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
        guard (1...5).contains(images.count) else { throw PotiError.badRequest }
        let presignedUploads = try await repository.fetchPresignedUploads(fileExtensions: images.map(\.fileExtension))
        guard images.count == presignedUploads.count else { throw PotiError.decodingError }
        var imagePaths: [String] = []

        for (image, presignedUpload) in zip(images, presignedUploads) {
            try await repository.uploadImage(data: image.data, to: presignedUpload.uploadURL, mimeType: image.mimeType)
            imagePaths.append(presignedUpload.filePath)
        }
        return imagePaths
    }
}
