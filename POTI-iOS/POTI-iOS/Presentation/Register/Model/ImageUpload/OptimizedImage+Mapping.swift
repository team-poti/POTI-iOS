//
//  OptimizedImage+Mapping.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

extension OptimizedImage {
    func toUploadImageEntity() -> UploadImageEntity {
        UploadImageEntity(data: data, fileExtension: fileExtension, mimeType: mimeType)
    }
}
