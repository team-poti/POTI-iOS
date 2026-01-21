//
//  GoodsListEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct GoodsListEntity {
    let nickname: String
    let mainArtist: String?
    let groupItems: [GroupItem]
    
    init(nickname: String, mainArtist: String?, groupItems: [GroupItem]) {
        self.nickname = nickname
        self.mainArtist = mainArtist
        self.groupItems = groupItems
    }
    
    func toGroupItemModel() -> [GroupItemModel] {
        return groupItems.map { $0.toGroupItemModel() }
    }
}

struct GroupItem {
    let title: String
    let artist: String
    let postImage: String?
    let postCount: Int
    let tag: String
    
    init(title: String, artist: String, postImage: String?, postCount: Int, tag: String) {
        self.title = title
        self.artist = artist
        self.postImage = postImage
        self.postCount = postCount
        self.tag = tag
    }
    
    func toGroupItemModel() -> GroupItemModel {
        GroupItemModel(
            title: title,
            artist: artist,
            postImage: postImage,
            postCount: postCount,
            tag: tag
        )
    }
}
