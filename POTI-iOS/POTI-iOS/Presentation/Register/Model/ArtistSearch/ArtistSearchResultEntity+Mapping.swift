//
//  ArtistSearchResultEntity+Mapping.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

extension ArtistSearchResultEntity {
    func toArtistSearchItem() -> ArtistSearchItem {
        ArtistSearchItem(id: artistId, name: name)
    }
}
