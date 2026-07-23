//
//  PotListDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct PotListDTO: Decodable {
    let postTitle: String?
    let artistId: Int?
    let artist: String?
    let currentPage: Int
    let hasNext: Bool
    let pots: [PotListItemDTO]?
    
    func toEntity() -> PotListEntity {
        PotListEntity(
            postTitle: postTitle ?? "",
            artistId: artistId ?? 0,
            artist: artist ?? "",
            currentPage: currentPage,
            hasNext: hasNext,
            pots: pots?.map { $0.toEntity() } ?? []
        )
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
    let recruiter: RecruiterDTO
    
    enum CodingKeys: String, CodingKey {
        case potId, price, thumbnailUrl, currentCount, totalCount, status, availableMembers
        case recruiter = "uploader"
    }
    
    func toEntity() -> Pot {
        Pot(
            potId: potId,
            price: price,
            thumbnailUrl: thumbnailUrl,
            currentCount: currentCount,
            totalCount: totalCount,
            status: status,
            availableMembers: availableMembers,
            recruiter: recruiter.toEntity()
        )
    }
}

struct RecruiterDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String?
    let rating: Double
    
    func toEntity() -> Recruiter {
        Recruiter(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage ?? "",
            rating: rating
        )
    }
}
