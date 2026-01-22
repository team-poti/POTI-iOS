//
//  MyPagePostsHistoryEntity.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import Foundation

struct MyPagePostsHistoryEntity {
    let inProgressCount: Int
    let completedCount: Int
    let currentStatus: String
    let groupBuyPosts: [MyPageGroupBuyPostEntity]
}

struct MyPageGroupBuyPostEntity {
    let groupBuyId: Int
    let artistName: String
    let productName: String
    let thumbnailUrl: String
    let status: String
    let createdAt: String
    
    func toModel() -> MyPageHistoryModel {
        return .init(
            id: groupBuyId,
            artistName: artistName,
            productName: productName,
            status: MyPageGroupBuyStatus(rawValue: status) ?? .recruiting,
            thumbnailURL: thumbnailUrl
        )
    }
}
