//
//  YourPageEntity.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct YourPageEntity: Decodable {
    let userId: Int
    let nickname: String
    let email: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let hasFavoriteArtist: Bool
    let recruitSummary: YourPageRecruitSummaryEntity
    
    func toModel() -> YourPageModel {
        return .init(
            userId: userId,
            nickname: nickname,
            email: email,
            profileImage: profileImageUrl,
            ratingAverage: ratingAvg,
            activityMessage: activityMessage,
            joinedDate: joinedAt,
            recruitSummary: recruitSummary.toModel()
        )
    }
}

struct YourPageRecruitSummaryEntity: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
    
    func toModel() -> RecruitSummary {
        return RecruitSummary(
            totalCount: total,
            inProgressCount: inProgress,
            completedCount: completed
        )
    }
}
