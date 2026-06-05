//
//  GroupItem+Mapping.swift
//  POTI-iOS
//
//  Created by mandoo on 6/5/26.
//

extension GroupItem {
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
