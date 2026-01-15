//
//  GoodsListEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct GoodsListEntity {
    let nickname: String
    let mainArtist: String?
    let groupItems: [GroupItem]
}

struct GroupItem {
    let title: String
    let artist: String
    let postImage: String?
    let postCount: Int
    let tag: String
}
