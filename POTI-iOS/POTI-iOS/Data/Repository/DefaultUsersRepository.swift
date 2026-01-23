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
    
    func getMyPageInformation() async throws -> MyPageEntity {
        let result = try await networkService.request(
            target: UsersAPI.getMyPageInformation,
            type: MyPageResponseDTO.self
        )
        return result.toEntity()
    }
    
    func getYourPageInformation(userId: Int) async throws -> YourPageEntity {
        let result = try await networkService.request(
            target: UsersAPI.fetchYourPageInformation(userId: userId),
            type: YourPageResponseDTO.self
        )
        return result.toEntity()
    }
}
