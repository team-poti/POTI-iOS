//
//  PresignedUrlDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import Foundation

struct PresignedUrlResponseDTO: Decodable {
    let data: DataContainer

    struct DataContainer: Decodable {
        let urls: [PresignedUrlDTO]
    }
}

struct PresignedUrlDTO: Decodable {
    let fileName: String
    let url: String
}

extension PresignedUrlDTO {
    func toEntity() throws -> PresignedUrlEntity {
        guard let uploadUrl = URL(string: url) else {
            throw PotiError.invalidPresignedUrl
        }

        return PresignedUrlEntity(
            uploadUrl: uploadUrl,
            fileName: fileName
        )
    }
}

//extension Array where Element == PresignedUrlDTO {
//    func toEntity() -> PresignedUrlEntity {
//        PresignedUrlEntity(
//            presignedUrls: self.map { $0.toEntity() }
//        )
//    }
//}
//
//extension PresignedUrlDTO {
//    func toEntity() -> PresignedUrlInfo {
//        PresignedUrlInfo(
//            fileName: fileName,
//            url: url
//        )
//    }
//}
