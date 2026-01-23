//
//  YourPageResponseDTO.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct YourPageResponseDTO: Decodable {
    let userId: Int
    let nickname: String
    let email: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let hasFavoriteArtist: Bool
    let recruitSummary: YourPageRecruitSummaryDTO
    
    func toEntity() -> YourPageEntity {
        return .init(
            userId: userId,
            nickname: nickname,
            email: email,
            profileImageUrl: profileImageUrl,
            ratingAvg: ratingAvg,
            activityMessage: activityMessage,
            joinedAt: joinedAt,
            hasFavoriteArtist: hasFavoriteArtist,
            recruitSummary: recruitSummary.toEntity()
        )
    }
}

struct YourPageRecruitSummaryDTO: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
    
    func toEntity() -> YourPageRecruitSummaryEntity {
        return .init(
            total: total,
            inProgress: inProgress,
            completed: completed
        )
    }
}
