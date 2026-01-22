//
//  MyPageEntity.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

struct MyPageEntity: Decodable {
    let userId: Int
    let nickname: String
    let email: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let hasFavoriteArtist: Bool
    let favoriteArtistName: String?
    let participationSummary: MyPageParticipationSummaryEntity
    let recruitSummary: MyPageRecruitSummaryEntity
    
    func toModel() -> MyPageModel {
        return .init(
            userId: userId,
            nickname: nickname,
            email: email,
            profileImage: profileImageUrl,
            ratingAverage: ratingAvg,
            activityMessage: activityMessage,
            joinedDate: joinedAt,
            hasFavoriteArtist: hasFavoriteArtist,
            favoriteArtistName: favoriteArtistName,
            participationSummary: participationSummary.toModel(),
            recruitSummary: recruitSummary.toModel()
        )
    }
}

struct MyPageParticipationSummaryEntity: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
    
    func toModel() -> ParticipationSummary {
        return ParticipationSummary(
            totalCount: total,
            inProgressCount: inProgress,
            completedCount: completed
        )
    }
}

struct MyPageRecruitSummaryEntity: Decodable {
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
