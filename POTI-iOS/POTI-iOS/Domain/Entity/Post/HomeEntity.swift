//
//  HomeEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct HomeEntity {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int?
    let myGroupItems: [GoodsEntity]
    let otherGroupItems: [GoodsEntity]
    let banners: [BannerEntity]
}

struct GoodsEntity {
    let artist: String
    let artistId: Int
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String
}

struct BannerEntity {
    let postId: Int
    let imageUrl: String
}

