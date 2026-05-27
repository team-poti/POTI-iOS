//
//  HomeDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct HomeDTO: Decodable {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int?
    let myGroupItems: [GoodsDTO]
    let otherGroupItems: [GoodsDTO]
    let banners: [BannerDTO]
    
    func toEntity() -> HomeEntity {
        return .init(
            nickname: nickname,
            mainArtist: mainArtist,
            mainArtistId: mainArtistId,
            myGroupItems: myGroupItems.map { $0.toEntity() },
            otherGroupItems: otherGroupItems.map { $0.toEntity() },
            banners: banners.map { $0.toEntity() }
        )
    }
}

struct GoodsDTO: Decodable {
    let artist: String?
    let artistId: Int?
    let postImage: String?
    let postTitle: String?
    let postCount: Int?
    let tag: String?
    
    func toEntity() -> GoodsEntity {
        return .init(
            artist: artist ?? "unknown artist",
            artistId: artistId ?? 0,
            postImage: postImage,
            postTitle: postTitle ?? "unknown title",
            postCount: postCount ?? 0,
            tag: tag ?? ""
        )
    }
}

struct BannerDTO: Decodable {
    let postId: Int
    let imageUrl: String
    
    func toEntity() -> BannerEntity {
        return .init(postId: postId, imageUrl: imageUrl)
    }
}
