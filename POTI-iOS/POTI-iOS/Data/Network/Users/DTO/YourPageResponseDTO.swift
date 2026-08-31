//
//  YourPageResponseDTO.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

struct YourPageResponseDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let ratingAvg: Double
    let activityMessage: String
    let joinedAt: String
    let hasFavoriteArtist: Bool?
    let participationSummary: YourPageSummaryDTO
    let recruitSummary: YourPageSummaryDTO
    
    func toEntity() -> YourPageEntity {
        return .init(
            userId: userId,
            nickname: nickname,
            profileImageUrl: profileImageUrl,
            ratingAvg: ratingAvg,
            activityMessage: activityMessage,
            joinedAt: joinedAt,
            hasFavoriteArtist: hasFavoriteArtist ?? false,
            participationSummary: participationSummary.toEntity(),
            recruitSummary: recruitSummary.toEntity()
        )
    }
}

struct YourPageSummaryDTO: Decodable {
    let inProgress: Int
    let completed: Int
    
    func toEntity() -> YourPageSummaryEntity {
        return .init(
            inProgress: inProgress,
            completed: completed
        )
    }
}
