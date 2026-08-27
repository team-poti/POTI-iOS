//
//  UploadProfileImageUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/24/26.
//

import Foundation

protocol UploadProfileImageUseCase {
    func execute(image: UploadImageEntity) async throws -> String
}

final class DefaultUploadProfileImageUseCase: UploadProfileImageUseCase {
    private let repository: ImageUploadInterface

    init(repository: ImageUploadInterface) {
        self.repository = repository
    }

    func execute(image: UploadImageEntity) async throws -> String {
        let presignedUpload = try await repository.fetchProfilePresignedUpload(
            fileExtension: image.fileExtension
        )
        try await repository.uploadImage(
            data: image.data,
            to: presignedUpload.uploadURL,
            mimeType: image.mimeType
        )
        return presignedUpload.filePath
    }
}
