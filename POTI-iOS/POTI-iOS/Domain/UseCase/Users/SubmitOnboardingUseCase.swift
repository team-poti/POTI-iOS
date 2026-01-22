//
//  SubmitOnboardingUseCase.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

protocol SubmitOnboardingUseCase {
    func execute(nickname: String, favoriteArtistId: Int?) async throws -> OnboardingSubmitEntity
}

final class DefaultSubmitOnboardingUseCase: SubmitOnboardingUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(nickname: String, favoriteArtistId: Int?) async throws -> OnboardingSubmitEntity {
        return try await repository.submitOnboarding(nickname: nickname, favoriteArtistId: favoriteArtistId)
    }
}
