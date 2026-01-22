//
//  OnboardingArtistsUsecase.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

protocol OnboardingArtistsUsecase {
    func execute() async throws -> OnboardingArtistsEntity
}

final class DefaultOnboardingArtistsUsecase: OnboardingArtistsUsecase {
    
    private let repository: ArtistsInterface
    
    init(repository: ArtistsInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> OnboardingArtistsEntity {
        return try await repository.fetchOnboardingArtists()
    }
}
