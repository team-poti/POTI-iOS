//
//  BannerModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/16/26.
//

import UIKit

enum BannerDeepLinkDestination: String {
    case favoriteArtist = "favorite-artist"
    case potCreate = "pot-create"

    init?(deeplink: String) {
        let trimmedDeeplink = deeplink.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedDeeplink.isEmpty else { return nil }

        let path = URLComponents(string: trimmedDeeplink)?.path ?? trimmedDeeplink
        let normalizedPath = path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()

        self.init(rawValue: normalizedPath)
    }
}

struct BannerModel {
    let id: Int
    let imageUrl: String
    let deeplink: String

    var localImage: UIImage? {
        guard URL(string: imageUrl)?.scheme == nil else { return nil }
        return UIImage(named: imageUrl)
    }

    static let defaultBanners: [BannerModel] = [
        BannerModel(id: -1, imageUrl: "img-banner1", deeplink: ""),
        BannerModel(id: -2, imageUrl: "img-banner2", deeplink: BannerDeepLinkDestination.favoriteArtist.rawValue),
        BannerModel(id: -3, imageUrl: "img-banner3", deeplink: BannerDeepLinkDestination.potCreate.rawValue)
    ]
}
