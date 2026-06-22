//
//  PotListEntity+Mapping.swift
//  POTI-iOS
//
//  Created by mandoo on 6/5/26.
//

import Foundation

extension PotListEntity {
    func toPotListModel() -> [PotModel] {
        return pots.map { $0.toPotModel() }
    }
}

extension Pot {
    func toPotModel() -> PotModel {
        return PotModel(
            potId: potId,
            recruiter: recruiter.toRecruiterModel(),
            currentCount: currentCount,
            totalCount: totalCount,
            availableMembers: availableMembers,
            price: price,
            thumbnailUrl: thumbnailUrl,
            status: status
        )
    }
}

extension Recruiter {
    func toRecruiterModel() -> RecruiterModel {
        return RecruiterModel(userId: userId, nickname: nickname, profileImage: profileImage, rating: rating)
    }
}
