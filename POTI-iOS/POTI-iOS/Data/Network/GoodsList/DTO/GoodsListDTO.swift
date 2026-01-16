//
//  GoodsListDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct GoodsListDTO: Decodable {
    let nickname: String
    let mainArtist: String?
    let groupItems: [GoodsListItemDTO]
}

struct GoodsListItemDTO: Decodable {
    let title: String
    let artist: String
    let postImage: String?
    let postCount: Int
    let tag: String
    
    func toEntity() -> GroupItem {
        return .init(title: title, artist: artist, postImage: postImage, postCount: postCount, tag: tag)
    }
}

extension GoodsListDTO {
    func toEntity() -> GoodsListEntity {
        return .init(nickname: nickname, mainArtist: mainArtist, groupItems: groupItems.map { $0.toEntity() }
        )
    }
}
