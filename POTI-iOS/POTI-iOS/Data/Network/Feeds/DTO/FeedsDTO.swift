//
//  FeedsDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct FeedsDTO: Decodable {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int?
    let groupItems: [GroupItemDTO]?
    
    func toEntity() -> FeedsEntity {
        FeedsEntity(
            nickname: nickname,
            mainArtist: mainArtist,
            mainArtistId: mainArtistId,
            groupItems: groupItems?.map { $0.toEntity() } ?? []
        )
    }
}

struct GroupItemDTO: Decodable {
    let title: String?
    let artist: String?
    let artistId: Int?
    let postImage: String?
    let postCount: Int?
    let tag: String?
    
    func toEntity() -> GroupItem {
        GroupItem(
            title: title ?? "",
            artist: artist ?? "",
            artistId: artistId ?? -1,
            postImage: postImage,
            postCount: postCount ?? 0,
            tag: tag ?? ""
        )
    }
}
