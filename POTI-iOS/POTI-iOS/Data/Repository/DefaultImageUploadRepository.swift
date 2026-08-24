//
//  DefaultImageUploadRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation

final class DefaultImageUploadRepository: ImageUploadInterface {
    private let imageUploadService: ImageUploadService

    init(imageUploadService: ImageUploadService) {
        self.imageUploadService = imageUploadService
    }

    func fetchPresignedUploads(fileExtensions: [String]) async throws -> [PresignedUploadEntity] {
        let response = try await imageUploadService.fetchPostPresignedUploads(fileExtensions: fileExtensions)
        return try response.toEntity()
    }

    func fetchProfilePresignedUpload(fileExtension: String) async throws -> PresignedUploadEntity {
        let response = try await imageUploadService.fetchProfilePresignedUpload(fileExtension: fileExtension)
        guard let presignedUpload = try response.toEntity().first else {
            throw PotiError.invalidPresignedUrl
        }
        return presignedUpload
    }

    func uploadImage(data: Data, to url: URL, mimeType: String) async throws {
        try await imageUploadService.uploadImage(data: data, to: url, mimeType: mimeType)
    }
}
