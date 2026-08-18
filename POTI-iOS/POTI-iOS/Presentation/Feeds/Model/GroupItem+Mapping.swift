//
//  GroupItem+Mapping.swift
//  POTI-iOS
//
//  Created by soomin on 6/5/26.
//

extension GroupItem {
    func toGoodsListItemModel() -> GoodsListItemModel {
        GoodsListItemModel(
            artist: artist,
            artistId: artistId,
            postImage: postImage,
            title: title,
            postCount: postCount,
            tag: tag
        )
    }
}
