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
    private let repository: ImagesInterface

    init(repository: ImagesInterface) {
        self.repository = repository
    }

    func execute(imageData: Data) async throws -> String {
        let presignedUrl = try await repository.fetchProfilePresignedUrl(fileExtension: "jpg")
        try await repository.uploadImage(data: imageData, to: presignedUrl.uploadUrl)
        return presignedUrl.fileName
    }
}
