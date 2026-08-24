//
//  SearchEntity+Mapping.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

extension SearchResultEntity {
    func toGoodsListItemModel() -> GoodsListItemModel {
        return GoodsListItemModel(artist: artist, artistId: artistId, postImage: postImage, title: postTitle, postCount: postCount, tag: tag)
    }
}
