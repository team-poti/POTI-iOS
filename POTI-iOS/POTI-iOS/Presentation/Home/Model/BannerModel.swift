//
//  BannerModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/16/26.
//

import Foundation

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
}
