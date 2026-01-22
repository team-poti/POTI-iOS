//
//  UsersInterface.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

protocol UsersInterface {
    func validateNickname(_ nickname: String) async throws -> Bool
    func submitOnboarding(nickname: String, favoriteArtistId: Int?) async throws -> OnboardingSubmitEntity
    func getMyPageInformation() async throws -> MyPageEntity
}
