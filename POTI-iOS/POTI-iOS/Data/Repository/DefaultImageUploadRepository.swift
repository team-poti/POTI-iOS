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

    func uploadImage(data: Data, to url: URL, mimeType: String) async throws {
        try await imageUploadService.uploadImage(data: data, to: url, mimeType: mimeType)
    }
}
