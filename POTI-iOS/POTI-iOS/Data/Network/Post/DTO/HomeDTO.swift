//
//  HomeDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/15/26.
//

struct HomeDTO: Decodable {
    let nickname: String?
    let mainArtist: String?
    let mainArtistId: Int?
    let myGroupItems: [GoodsDTO]
    let otherGroupItems: [GoodsDTO]
    let banners: [BannerDTO]
    
    func toEntity() -> HomeEntity {
        HomeEntity(
            nickname: nickname ?? "포티",
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
        GoodsEntity(
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
    let id: Int
    let imageUrl: String
    let deeplink: String

    private enum CodingKeys: String, CodingKey {
        case id
        case postId
        case imageUrl
        case deeplink
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
            ?? container.decode(Int.self, forKey: .postId)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        deeplink = try container.decodeIfPresent(String.self, forKey: .deeplink) ?? ""
    }
    
    func toEntity() -> BannerEntity {
        BannerEntity(id: id, imageUrl: imageUrl, deeplink: deeplink)
    }
}
