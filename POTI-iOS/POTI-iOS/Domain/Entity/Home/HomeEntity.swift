//
//  HomeEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct HomeEntity {
    let nickname: String
    let mainArtist: String?
    let myGroupItems: [GoodsItem]
    let otherGroupItems: [GoodsItem]
    let banners: [BannerItem]
}

struct GoodsItem {
    let artist: String
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String
}

struct BannerItem {
    let postId: Int
    let imageUrl: String
}
