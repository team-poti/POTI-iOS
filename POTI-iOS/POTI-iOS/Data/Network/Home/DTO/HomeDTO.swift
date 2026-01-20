//
//  HomeDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct HomeDTO: Decodable {
    let nickname: String
    let mainArtist: String?
    let myGroupItems: [GoodsItemDTO]
    let otherGroupItems: [GoodsItemDTO]
    let banners: [BannerItemDTO]
}

struct GoodsItemDTO: Decodable {
    let artist: String
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String
    
    func toEntity() -> GoodsItem {
        return .init(artist: artist, postImage: postImage, postTitle: postTitle, postCount: postCount, tag: tag)
    }
}

struct BannerItemDTO: Decodable {
    let postId: Int
    let imageUrl: String
    
    func toEntity() -> BannerItem {
        return .init(postId: postId, imageUrl: imageUrl)
    }
}

extension HomeDTO {
    func toEntity() -> HomeEntity {
        return .init(
            nickname: nickname,
            mainArtist: mainArtist,
            myGroupItems: myGroupItems.map { $0.toEntity() },
            otherGroupItems: otherGroupItems.map { $0.toEntity() },
            banners: banners.map { $0.toEntity() }
        )
    }
}
