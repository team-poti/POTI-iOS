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

    func fetchPresignedURLs(fileExtensions: [String]) async throws -> [PresignedUploadEntity] {
        let response = try await imageUploadService.fetchPresignedURLs(type: "POST", fileExtensions: fileExtensions)
        return try response.map { try $0.toEntity() }
    }

    func uploadImage(data: Data, to url: URL, mimeType: String) async throws {
        try await imageUploadService.uploadImage(data: data, to: url, mimeType: mimeType)
    }
}
