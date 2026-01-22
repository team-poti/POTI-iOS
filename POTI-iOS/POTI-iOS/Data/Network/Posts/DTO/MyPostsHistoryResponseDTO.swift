//
//  MyPostsHistoryResponseDTO.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import Foundation

struct MyPostsHistoryResponseDTO: Decodable {
    let inProgressCount: Int
    let completedCount: Int
    let currentStatus: String
    let groupBuyPosts: [MyPageGroupBuyPostDTO]
    
    func toEntity() -> MyPagePostsHistoryEntity {
        return .init(
            inProgressCount: inProgressCount,
            completedCount: completedCount,
            currentStatus: currentStatus,
            groupBuyPosts: groupBuyPosts.map {
                $0.toEntity()
            }
        )
    }
}

struct MyPageGroupBuyPostDTO: Decodable {
    let groupBuyId: Int
    let artistName: String
    let productName: String
    let thumbnailUrl: String
    let status: String
    let createdAt: String
    
    func toEntity() -> MyPageGroupBuyPostEntity {
        return .init(
            groupBuyId: groupBuyId,
            artistName: artistName,
            productName: productName,
            thumbnailUrl: thumbnailUrl,
            status: status,
            createdAt: createdAt
        )
    }
}
