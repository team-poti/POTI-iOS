//
//  GoodsListDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct GoodsListDTO: Decodable {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int?
    let hasNext: Bool?
    let groupItems: [GoodsListItemDTO]?
    
    func toEntity() -> GoodsListEntity {
        return .init(
            nickname: nickname,
            mainArtist: mainArtist,
            mainArtistId: mainArtistId ?? -1,
            hasNext: hasNext ?? false,
            groupItems: groupItems?.map { $0.toEntity() } ?? []
        )
    }
}

struct GoodsListItemDTO: Decodable {
    let artist: String?
    let artistId: Int?
    let postImage: String?
    let postTitle: String?
    let postCount: Int?
    let tag: String?
    
    func toEntity() -> GroupItem {
        return .init(
            title: postTitle ?? "", 
            artist: artist ?? "",
            postImage: postImage,
            postCount: postCount ?? 0,
            tag: tag ?? ""
        )
    }
}
