//
//  YourPageEntity.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct YourPageEntity: Decodable {
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let participationSummary: YourPageSummaryEntity
    let recruitSummary: YourPageSummaryEntity
    
    func toModel() -> YourPageModel {
        return .init(
            userId: userId,
            nickname: nickname,
            profileImage: profileImageUrl,
            ratingAverage: ratingAvg,
            activityMessage: activityMessage,
            joinedDate: joinedAt,
            participationSummary: participationSummary.toModel(),
            recruitSummary: recruitSummary.toModel()
        )
    }
}

struct YourPageSummaryEntity: Decodable {
    let inProgress: Int
    let completed: Int
    
    func toModel() -> YourPageSummary {
        return YourPageSummary(
            inProgressCount: inProgress,
            completedCount: completed
        )
    }
}
