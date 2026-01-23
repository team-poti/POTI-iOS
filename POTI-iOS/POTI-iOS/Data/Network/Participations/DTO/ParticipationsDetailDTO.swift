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
    let paymentInfo: JoinPaymentDTO
    let shippingInfo: JoinShippingDTO

    private enum CodingKeys: String, CodingKey {
        case participationId
        case postId
        case orderNumber
        case imageUrl
        case artistName
        case title
        case postStatus = "status"
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
    let carrier: String?
    let trackingNumber: String?
    let shippingStatus: String
}

// MARK: - DTO → Entity Mapping

extension ParticipationDetailDTO {
    func toEntity() -> JoinDetailEntity {
        JoinDetailEntity(
            participationId: participationId,
            postId: postId,
            orderNumber: orderNumber,
            imageUrl: imageUrl,
            artistName: artistName,
            title: title,
            postStatus: PostStatus(rawValue: postStatus) ?? .recruiting,
            statusMessage: statusMessage,
            memberPayments: memberPayments.map { $0.toEntity() },
            paymentInfo: paymentInfo.toEntity(),
            shippingInfo: shippingInfo.toEntity()
        )
    }
}

extension MemberPaymentDTO {
    func toEntity() -> JoinMemberPaymentEntity {
        JoinMemberPaymentEntity(
            memberName: memberName,
            price: price
        )
    }
}

extension JoinPaymentDTO {
    func toEntity() -> JoinPaymentEntity {
        JoinPaymentEntity(
            shippingFee: shippingFee,
            totalAmount: totalAmount,
            depositStatus: ParticipantOrderStatus(rawValue: depositStatus) ?? .waitPay,
            bank: bank,
            accountNumber: accountNumber,
            depositDeadline: depositDeadline
        )
    }
}

extension JoinShippingDTO {
    func toEntity() -> JoinShippingEntity {
        JoinShippingEntity(
            shippingMethod: shippingMethod,
            receiver: receiver,
            zipcode: zipcode,
            address: address,
            phone: phone,
            carrier: carrier ?? "",
            trackingNumber: trackingNumber ?? "",
            shippingStatus: ParticipantOrderStatus(rawValue: shippingStatus) ?? .waitPay
            )
    }
}
