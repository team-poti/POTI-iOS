//
//  ParticipantModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

struct ParticipantModel {
    let userInfo: ParticipantInfoModel
    let selectedMember: String
}

struct ParticipantInfoModel {
    let userId: Int
    let nickname: String
    let profileImage: String
    let rating: Double
    let selectedMembers: [String]
}
