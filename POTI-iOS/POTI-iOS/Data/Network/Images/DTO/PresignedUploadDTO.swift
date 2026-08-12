//
//  PresignedUploadDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation

struct PresignedUploadDTO: Decodable {
    let fileName: String
    let url: String

    func toEntity() throws -> PresignedUploadEntity {
        guard let uploadURL = URL(string: url) else { throw PotiError.invalidPresignedUrl }
        return PresignedUploadEntity(fileName: fileName, uploadURL: uploadURL)
    }
}
