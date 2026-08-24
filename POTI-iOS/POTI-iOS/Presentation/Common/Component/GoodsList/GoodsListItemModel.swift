//
//  GoodsListItemModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct GoodsListItemModel {
    let artist: String
    let artistId: Int?
    let postImage: String?
    let title: String
    let postCount: Int
    let tag: String?

    var postCountText: String {
        return "팟 \(postCount)개"
    }

    var hasPopularTag: Bool {
        return tag == "인기"
    }
}
