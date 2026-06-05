//
//  GroupItemModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

struct GroupItemModel {
    let title: String
    let artist: String
    let artistId: Int?
    let postImage: String?
    let postCount: Int
    let tag: String
    
    var potCountText: String {
        return "팟 \(postCount)개"
    }
    
    var hasPopularTag: Bool {
        return tag == "인기"
    }
}
