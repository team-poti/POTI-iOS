//
//  OnboardingArtistsResponseDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

struct OnboardingArtistsResponseDTO: Decodable {
    let artists: [OnboardingArtistsDTO]
}

struct OnboardingArtistsDTO: Decodable {
    let artistId: Int
    let name: String
    let logoImageUrl: String?
}

extension OnboardingArtistsResponseDTO {
    func toEntity() -> OnboardingArtistsEntity {
        OnboardingArtistsEntity(
            artists: artists.map { $0.toEntity() }
        )
    }
}

extension OnboardingArtistsDTO {
    func toEntity() -> OnboardingArtistEntity {
        OnboardingArtistEntity(
            artistId: artistId,
            name: name,
            logoImageUrl: logoImageUrl
        )
    }
}
