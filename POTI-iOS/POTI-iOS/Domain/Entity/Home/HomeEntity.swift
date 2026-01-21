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
    
    init(nickname: String, mainArtist: String?, myGroupItems: [GoodsItem], otherGroupItems: [GoodsItem], banners: [BannerItem]) {
        self.nickname = nickname
        self.mainArtist = mainArtist
        self.myGroupItems = myGroupItems
        self.otherGroupItems = otherGroupItems
        self.banners = banners
    }
    
    func toMyGoodsModelList() -> [GoodsModel] {
        return myGroupItems.map { $0.toGoodsModel() }
    }
    
    func toOtherGoodsModelList() -> [GoodsModel] {
        return otherGroupItems.map { $0.toGoodsModel() }
    }
    
    func toBannerModelList() -> [BannerModel] {
        return banners.map { $0.toBannerModel() }
    }
}

struct GoodsItem {
    let artist: String
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String
    
    init(artist: String, postImage: String?, postTitle: String, postCount: Int, tag: String) {
        self.artist = artist
        self.postImage = postImage
        self.postTitle = postTitle
        self.postCount = postCount
        self.tag = tag
    }
    
    func toGoodsModel() -> GoodsModel {
        return GoodsModel(artist: artist, postImage: postImage, postTitle: postTitle, postCount: postCount, tag: tag)
    }
}

struct BannerItem {
    let postId: Int
    let imageUrl: String
    
    init(postId: Int, imageUrl: String) {
        self.postId = postId
        self.imageUrl = imageUrl
    }
    
    func toBannerModel() -> BannerModel {
        return BannerModel(postId: postId, imageUrl: imageUrl)
    }
}

