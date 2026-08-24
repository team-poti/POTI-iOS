//
//  UploadProfileImageUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/24/26.
//

import Foundation

protocol UploadProfileImageUseCase {
    func execute(imageData: Data) async throws -> String
}

final class DefaultUploadProfileImageUseCase: UploadProfileImageUseCase {
    private let repository: ImageUploadInterface

    init(repository: ImageUploadInterface) {
        self.repository = repository
    }

    func execute(imageData: Data) async throws -> String {
        let presignedUpload = try await repository.fetchProfilePresignedUpload(fileExtension: "jpg")
        try await repository.uploadImage(
            data: imageData,
            to: presignedUpload.uploadURL,
            mimeType: "image/jpeg"
        )
        return presignedUpload.filePath
    }
}
