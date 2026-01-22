//
//  DefaultImagesRepository.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import UIKit

final class DefaultImagesRepository: ImagesInterface {
    
    private let imageUploadService: ImageUploadService
    
    init(imageUploadService: ImageUploadService) {
        self.imageUploadService = imageUploadService
    }
    
    func uploadImages(images: [UIImage]) async throws -> [String] {
        // 1. 확장자 배열 생성 (모두 jpg로)
        let extensions = images.map { _ in "jpg" }
        
        // 2. Presigned URL 받기 (type은 "POST"로 고정)
        let presignedUrls = try await imageUploadService.getPresignedUrls(
            type: "POST",
            extensions: extensions
        )
        
        // 3. 각 이미지를 S3에 업로드
        var uploadedFileNames: [String] = []
        
        for (index, image) in images.enumerated() {
            let presignedUrl = presignedUrls[index].url
            try await imageUploadService.uploadImage(image: image, to: presignedUrl)
            uploadedFileNames.append(presignedUrls[index].fileName)
        }
        
        PotiLogger.debug("이미지 업로드 완료: \(uploadedFileNames)")
        return uploadedFileNames
    }
}
