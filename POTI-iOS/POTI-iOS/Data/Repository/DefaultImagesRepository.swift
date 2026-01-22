//
//  DefaultImagesRepository.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import Foundation

final class DefaultImagesRepository: ImagesInterface {
    
    private let imageUploadService: ImageUploadService
    
    init(imageUploadService: ImageUploadService) {
        self.imageUploadService = imageUploadService
    }
    
    func fetchPresignedUrls(count: Int) async throws -> [PresignedUrlEntity] {
        let extensions = Array(repeating: "jpg", count: count)
        let response = try await imageUploadService.getPresignedUrls(
            type: "POST",
            extensions: extensions
        )
        
        return try response.data.urls.map { try $0.toEntity() }
    }
    
    func uploadImage(data: Data, to url: URL) async throws {
        try await imageUploadService.uploadImage(data: data, to: url)
    }
}
