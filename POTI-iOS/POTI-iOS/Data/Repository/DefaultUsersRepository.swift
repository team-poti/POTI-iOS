//
//  DefaultUsersRepository.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

final class DefaultUsersRepository: UsersInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func validateNickname(_ nickname: String) async throws -> Bool {
        let result = try await networkService.request(
            target: UsersAPI.validateNickname(nickname: nickname),
            type: NicknameValidationDTO.self
        )
        return result.isDuplicated
    }
    
    func submitOnboarding(nickname: String, favoriteArtistId: Int?) async throws -> OnboardingSubmitEntity {
        let result = try await networkService.request(
            target: UsersAPI.submitOnboarding(
                nickname: nickname,
                favoriteArtistId: favoriteArtistId
            ),
            type: OnboardingSubmitDTO.self
        )
        return result.toEntity()
    }
}
