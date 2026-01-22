//
//  MyPageResponseDTO.swift
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
}

struct MyPageParticipationSummaryEntity: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
}

struct MyPageRecruitSummaryEntity: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
}
