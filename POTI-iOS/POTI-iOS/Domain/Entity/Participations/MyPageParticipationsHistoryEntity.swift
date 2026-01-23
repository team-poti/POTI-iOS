//
//  MyPageParticipationsHistoryEntity.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct MyPageParticipationsHistoryEntity {
    let inProgressCount: Int
    let completedCount: Int
    let currentStatus: String
    let participations: [MyPageParticipationEntity]
}

struct MyPageParticipationEntity {
    let participationId: Int
    let groupBuyId: Int
    let artistName: String
    let productName: String
    let thumbnailUrl: String?
    let postStatus: String
    
    func toModel() -> MyPageHistoryModel {
        return .init(
            id: participationId,
            artistName: artistName,
            productName: productName,
            status: MyPageGroupBuyStatus(rawValue: postStatus) ?? .recruiting,
            thumbnailURL: thumbnailUrl
        )
    }
}
