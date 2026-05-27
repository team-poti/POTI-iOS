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
    
    func toMyGoodsModels() -> [GoodsModel] {
        return myGroupItems.map { $0.toGoodsModel() }
    }
    
    func toOtherGoodsModels() -> [GoodsModel] {
        return otherGroupItems.map { $0.toGoodsModel() }
    }
    
    func toBannerModels() -> [BannerModel] {
        return banners.map { $0.toBannerModel() }
    }
}

struct GoodsEntity {
    let artist: String
    let artistId: Int
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String
    
    func toGoodsModel() -> GoodsModel {
        return GoodsModel(artist: artist, artistId: artistId, postImage: postImage, postTitle: postTitle, postCount: postCount, tag: tag)
    }
}

struct BannerEntity {
    let postId: Int
    let imageUrl: String
    
    func toBannerModel() -> BannerModel {
        return BannerModel(postId: postId, imageUrl: imageUrl)
    }
}

