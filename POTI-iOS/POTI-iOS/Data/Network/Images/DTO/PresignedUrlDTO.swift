//
//  PresignedUrlDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

typealias PresignedUrlResponseDTO = [PresignedUrlDTO]

struct PresignedUrlDTO: Decodable {
    let fileName: String
    let url: String
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
