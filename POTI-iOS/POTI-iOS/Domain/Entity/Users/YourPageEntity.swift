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
    let hasFavoriteArtist: Bool
    let participationSummary: YourPageSummaryEntity
    let recruitSummary: YourPageSummaryEntity

    init(
        userId: Int,
        nickname: String,
        profileImageUrl: String?,
        ratingAvg: Double,
        activityMessage: String,
        joinedAt: String,
        hasFavoriteArtist: Bool = false,
        participationSummary: YourPageSummaryEntity,
        recruitSummary: YourPageSummaryEntity
    ) {
        self.userId = userId
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.ratingAvg = ratingAvg
        self.activityMessage = activityMessage
        self.joinedAt = joinedAt
        self.hasFavoriteArtist = hasFavoriteArtist
        self.participationSummary = participationSummary
        self.recruitSummary = recruitSummary
    }
    
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
    var total: Int { inProgress + completed }
    
    func toModel() -> YourPageSummary {
        return YourPageSummary(
            inProgressCount: inProgress,
            completedCount: completed
        )
    }
}
