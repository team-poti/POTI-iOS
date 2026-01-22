//
//  GoodsListEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct GoodsListEntity {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int
    let hasNext: Bool
    let groupItems: [GroupItem]
    
    init(nickname: String, mainArtist: String?, mainArtistId: Int, hasNext: Bool, groupItems: [GroupItem]) {
        self.nickname = nickname
        self.mainArtist = mainArtist
        self.mainArtistId = mainArtistId
        self.hasNext = hasNext
        self.groupItems = groupItems
    }
    
    func toGroupItemModel() -> [GroupItemModel] {
        return groupItems.map { $0.toGroupItemModel() }
    }
}

struct GroupItem {
    let title: String
    let artist: String
    let artistId: Int
    let postImage: String?
    let postCount: Int
    let tag: String
    
    init(title: String, artist: String, artistId: Int, postImage: String?, postCount: Int, tag: String) {
        self.title = title
        self.artist = artist
        self.artistId = artistId
        self.postImage = postImage
        self.postCount = postCount
        self.tag = tag
    }
    
    func toGroupItemModel() -> GroupItemModel {
        GroupItemModel(
            title: title,
            artist: artist,
            artistId: artistId,
            postImage: postImage,
            postCount: postCount,
            tag: tag
        )
    }
}
