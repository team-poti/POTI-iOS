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
}

struct ParticipationSummaryDTO: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
}

struct RecruitSummaryDTO: Decodable {
    let total: Int
    let inProgress: Int
    let completed: Int
}
