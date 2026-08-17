//
//  MockUserRepository.swift
//  POTI-iOS
//
//  Created by Neon on 7/2/26.
//

final class MockUserRepository: UsersInterface {
    func validateNickname(_ nickname: String) async throws -> Bool {
        return true
    }
    
    func submitOnboarding(nickname: String, favoriteArtistId: Int?) async throws -> OnboardingSubmitEntity {
        return OnboardingSubmitEntity(nickname: "네온", favoriteArtistId: 1)
    }
    
    func getMyPageInformation() async throws -> MyPageEntity {
        let participationInfo = MyPageParticipationSummaryEntity(total: 10, inProgress: 5, completed: 3)
        let recruitInfo = MyPageRecruitSummaryEntity(total: 10, inProgress: 5, completed: 3)
        return MyPageEntity(userId: 1, nickname: "네온", email: "neon@naver.com", profileImageUrl: "https://media.bunjang.co.kr/product/353092357_1_1756398019_w360.jpg", ratingAvg: 4.0, activityMessage: "최근 3일 이내 활동", joinedAt: "2025-12-28", hasFavoriteArtist: true, favoriteArtistName: "아이브", participationSummary: participationInfo, recruitSummary: recruitInfo)
    }
    
    func getYourPageInformation(userId: Int) async throws -> YourPageEntity {
        let recruitInfo = YourPageRecruitSummaryEntity(total: 33, inProgress: 22, completed: 1)
        return YourPageEntity(userId: 3, nickname: "하이루", email: "hi@hihi.com", profileImageUrl: "https://media.bunjang.co.kr/product/373927945_1_1767274552_w360.jpg", ratingAvg: 4.5, activityMessage: "최근 1일 이내 활동", joinedAt: "2025-12-28", hasFavoriteArtist: false, recruitSummary: recruitInfo)
    }
}
