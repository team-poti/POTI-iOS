//
//  OnboardingArtistsEntity.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

struct OnboardingArtistsEntity {
    let artists: [OnboardingArtistEntity]
}

struct OnboardingArtistEntity {
    let artistId: Int
    let name: String
    let logoImageUrl: String?
    
    func toIdolGroupModel() -> IdolGroupModel {
        IdolGroupModel(
            id: artistId,
            name: name,
            image: logoImageUrl
        )
    }
}
