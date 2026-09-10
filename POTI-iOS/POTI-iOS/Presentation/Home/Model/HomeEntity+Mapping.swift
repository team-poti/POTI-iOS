//
//  HomeEntity+Mapping.swift
//  POTI-iOS
//
//  Created by soomin on 6/5/26.
//

import Foundation

extension HomeEntity {
    func toMyGoodsModels() -> [GoodsModel] {
        myGroupItems.map { $0.toGoodsModel() }
    }

    func toOtherGoodsModels() -> [GoodsModel] {
        otherGroupItems.map { $0.toGoodsModel() }
    }

    func toBannerModels() -> [BannerModel] {
        guard !banners.isEmpty else { return BannerModel.defaultBanners }
        return banners.map { $0.toBannerModel() }
    }
}

extension GoodsEntity {
    func toGoodsModel() -> GoodsModel {
        GoodsModel(
            artist: artist,
            artistId: artistId,
            postImage: postImage,
            postTitle: postTitle,
            postCount: postCount,
            tag: tag
        )
    }
}

extension BannerEntity {
    func toBannerModel() -> BannerModel {
        BannerModel(
            id: id,
            imageUrl: imageUrl,
            deeplink: deeplink
        )
    }
}
