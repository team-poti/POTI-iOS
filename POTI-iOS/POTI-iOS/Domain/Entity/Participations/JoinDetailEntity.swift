//
//  JoinDetailEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import UIKit

struct JoinDetailEntity {
    let participationId: Int
    let postId: Int
    let orderNumber: String
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: PostStatus
    let statusMessage: String
    let memberPayments: [JoinMemberPaymentEntity]
    let paymentInfo: JoinPaymentEntity
    let shippingInfo: JoinShippingEntity
}

struct JoinMemberPaymentEntity: Decodable {
    let memberName: String
    let price: Int
}

struct JoinPaymentEntity {
    let shippingFee: Int
    let totalAmount: Int
    let depositStatus: ParticipantOrderStatus
    let bank: String?
    let accountNumber: String?
    let depositDeadline: String?
}

struct JoinShippingEntity {
    let shippingMethod: String
    let receiver: String
    let zipcode: String
    let address: String
    let phone: String
    let carrier: String
    let trackingNumber: String
    let shippingStatus: ParticipantOrderStatus
}
