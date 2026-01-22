//
//  OnboardingSubmitDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

struct OnboardingSubmitDTO: Codable {
    let nickname: String
    let favoriteArtistId: Int?
}

extension OnboardingSubmitDTO {
    func toEntity() -> OnboardingSubmitEntity {
        OnboardingSubmitEntity(
            nickname: nickname,
            favoriteArtistId: favoriteArtistId
        )
    }
}
