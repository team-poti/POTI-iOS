//
//  MyPageModel.swift
//  POTI-iOS
//
//  Created by neon on 1/18/26.
//

import Foundation

struct MyPageModel {
    let nickname: String
    let email: String
    let profileImage: String?
    let ratingAverage: Double
    let activityMessage: String
    let joinedDate: Date
    let hasFavoriteArtist: Bool
    let FavoriteArtistName: String?
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
