//
//  PresignedUploadsDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation

struct PresignedUploadsDTO: Decodable {
    let urls: [PresignedUploadDTO]

    func toEntity() throws -> [PresignedUploadEntity] {
        try urls.map { try $0.toEntity() }
    }
}

struct PresignedUploadDTO: Decodable {
    let fileName: String
    let url: String

    func toEntity() throws -> PresignedUploadEntity {
        guard let uploadURL = URL(string: url) else { throw PotiError.invalidPresignedUrl }
        return PresignedUploadEntity(filePath: fileName, uploadURL: uploadURL)
    }
}
