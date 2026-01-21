//
//  PotListDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

struct PotListDTO: Decodable {
    let postTitle: String
    let artistId: Int
    let artist: String
    let currentPage: Int
    let hasNext: Bool
    let pots: [PotListItemDTO]
    
    func toEntity() -> PotListEntity {
        return .init(postTitle: postTitle, artistId: artistId, artist: artist, currentPage: currentPage, hasNext: hasNext, pots: pots.map { $0.toEntity() })
    }
}

struct PotListItemDTO: Decodable {
    let potId: Int
    let price: Int
    let thumbnailUrl: String
    let currentCount: Int
    let totalCount: Int
    let status: String
    let availableMembers: [String]
    let uploader: UploaderDTO
    
    func toEntity() -> Pot {
        return .init(potId: potId, price: price, thumbnailUrl: thumbnailUrl, currentCount: currentCount, totalCount: totalCount, status: status, availableMembers: availableMembers, uploader: uploader.toEntity())
    }
}

struct UploaderDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String
    let rating: Double
    
    func toEntity() -> Uploader {
        return .init(userId: userId, nickname: nickname, profileImage: profileImage, rating: rating)
    }
}
