//
//  YourPageModel.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import Foundation

struct YourPageModel {
    let userId: Int
    let nickname: String
    let profileImage: String?
    let ratingAverage: Double
    let activityMessage: String
    let joinedDate: String
    let participationSummary: YourPageSummary
    let recruitSummary: YourPageSummary
}

struct YourPageSummary {
    let inProgressCount: Int
    let completedCount: Int
}
