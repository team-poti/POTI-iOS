//
//  MyPageModel.swift
//  POTI-iOS
//
//  Created by neon on 1/18/26.
//

import Foundation

struct MyPageModel {
    let userId: Int
    let nickname: String
    let email: String
    let profileImage: String?
    let ratingAverage: Double
    let activityMessage: String
    let joinedDate: String
    let hasFavoriteArtist: Bool
    let favoriteArtistName: String?
    let participationSummary: ParticipationSummary
    let recruitSummary: RecruitSummary
}

struct ParticipationSummary {
    let totalCount: Int
    let inProgressCount: Int
    let completedCount: Int
}

struct RecruitSummary {
    let totalCount: Int
    let inProgressCount: Int
    let completedCount: Int
}
