//
//  ParticipationEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct ParticipationEntity {
    let postId: Int
    let shippingId: Int
    let receiverName: String
    let zipcode: String
    let addressLine: String
    let phone: String
    let items: [ParticipationItem]
}

struct ParticipationItem {
    let optionId: Int
    let count: Int
}

struct ParticipationResponseEntity {
    let participationId: Int
}
