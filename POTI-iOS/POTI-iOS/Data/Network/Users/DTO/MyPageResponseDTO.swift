//
//  MyPageResponseDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

struct MyPageResponseDTO: Decodable {
    let userId: Int
    let nickname: String
    let email: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let hasFavoriteArtist: Bool
    let favoriteArtistName: String?
    let participationSummary: ParticipationSummaryDTO
    let recruitSummary: RecruitSummaryDTO
    
    func toEntity() -> MyPageEntity {
        return .init(
            userId: userId,
            nickname: nickname,
            email: email,
            profileImageUrl: profileImageUrl,
            ratingAvg: ratingAvg,
            activityMessage: activityMessage,
            joinedAt: joinedAt,
            hasFavoriteArtist: hasFavoriteArtist,
            favoriteArtistName: favoriteArtistName,
            participationSummary: participationSummary.toEntity(),
            recruitSummary: recruitSummary.toEntity()
        )
    }
}

struct ParticipationSummaryDTO: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
    
    func toEntity() -> MyPageParticipationSummaryEntity {
        return .init(
            total: total,
            inProgress: inProgress,
            completed: completed
        )
    }
}

struct RecruitSummaryDTO: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
    
    func toEntity() -> MyPageRecruitSummaryEntity {
        return .init(
            total: total,
            inProgress: inProgress,
            completed: completed
        )
    }
}
