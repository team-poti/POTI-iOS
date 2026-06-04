//
//  FeedsEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

enum FeedsSortOption: String {
    case hot = "HOT"
    case latest = "LATEST"
    case random = "RANDOM"
    
    var text: String {
        switch self {
        case .hot: 
            return "인기순"
        case .latest: 
            return "최신순"
        case .random:
            return ""
        }
    }
}

struct FeedsEntity {
    let nickname: String
    let mainArtist: String?
    let mainArtistId: Int?
    let groupItems: [GroupItem]
}

struct GroupItem {
    let title: String
    let artist: String
    let artistId: Int?
    let postImage: String?
    let postCount: Int
    let tag: String
    
    func toGroupItemModel() -> GroupItemModel {
        GroupItemModel(
            title: title,
            artist: artist,
            artistId: artistId ?? -1,
            postImage: postImage,
            postCount: postCount,
            tag: tag
        )
    }
}
