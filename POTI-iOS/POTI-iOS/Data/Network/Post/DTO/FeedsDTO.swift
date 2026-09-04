//
//  FeedsDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/15/26.
//

struct FeedsDTO: Decodable {
    let nickname: String?
    let mainArtist: String?
    let mainArtistId: Int?
    let hasNext: Bool
    let groupItems: [GroupItemDTO]?
    
    func toEntity() -> FeedsEntity {
        FeedsEntity(
            nickname: nickname ?? "",
            mainArtist: mainArtist,
            mainArtistId: mainArtistId,
            hasNext: hasNext,
            groupItems: groupItems?.map { $0.toEntity() } ?? []
        )
    }
}

struct GroupItemDTO: Decodable {
    let postTitle: String?
    let artist: String?
    let artistId: Int?
    let postImage: String?
    let postCount: Int?
    let tag: String?
    
    func toEntity() -> GroupItem {
        GroupItem(
            title: postTitle ?? "",
            artist: artist ?? "",
            artistId: artistId ?? -1,
            postImage: postImage,
            postCount: postCount ?? 0,
            tag: tag ?? ""
        )
    }
}
