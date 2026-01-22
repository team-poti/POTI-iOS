//
//  MyParticipationsResponseDTO.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct MyParticipationsResponseDTO: Decodable {
    let currentStatus: String
    let inProgressCount: Int
    let completedCount: Int
    let participations: [MyPageParticipationDTO]
    
    func toEntity() -> MyPageParticipationsHistoryEntity {
        return .init(
            inProgressCount: inProgressCount,
            completedCount: completedCount,
            currentStatus: currentStatus,
            participations: participations.map {
                $0.toEntity()
            }
        )
    }
}

struct MyPageParticipationDTO: Decodable {
    let participationId: Int
    let groupBuyId: Int
    let artistName: String
    let productName: String
    let thumbnailUrl: String?
    let postStatus: String
    
    func toEntity() -> MyPageParticipationEntity {
        return .init(
            participationId: participationId,
            groupBuyId: groupBuyId,
            artistName: artistName,
            productName: productName,
            thumbnailUrl: thumbnailUrl,
            postStatus: postStatus
        )
    }
}
