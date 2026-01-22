//
//  ParticipationsDetailDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Foundation

struct ParticipationDetailDTO: Decodable {
    let participationId: Int
    let postId: Int
    let orderNumber: String
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: String
    let statusMessage: String
    let memberPayments: [MemberPaymentDTO]
    let paymentInfo: JoinPaymentDTO?
    let shippingInfo: JoinShippingDTO?

    private enum CodingKeys: String, CodingKey {
        case participationId
        case postId
        case orderNumber
        case imageUrl
        case artistName
        case title
        case postStatus = "Status"
        case statusMessage
        case memberPayments
        case paymentInfo
        case shippingInfo
    }
}

enum PostStatusDTO: String, Decodable {
    case recruiting = "RECRUITING"
    case recruitCompleted = "RECRUIT_COMPLETED"
    case depositCompleted = "DEPOSIT_COMPLETED"
    case shipping = "SHIPPING"
    case completed = "COMPLETED"
}

struct MemberPaymentDTO: Decodable {
    let memberName: String
    let price: Int
}

struct JoinPaymentDTO: Decodable {
    let shippingFee: Int
    let totalAmount: Int
    let depositStatus: String
    let bank: String?
    let accountNumber: String?
    let depositDeadline: String?
}

struct JoinShippingDTO: Decodable {
    let shippingMethod: String
    let receiver: String
    let zipcode: String
    let address: String
    let phone: String
    let carrier: String
    let trackingNumber: String
    let shippingStatus: String
}
