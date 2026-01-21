//
//  MyPageJoinDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

struct MyPageJoinDTO: Decodable {
    let participationId: Int
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: String
    let orderStatus: String
    let statusMessage: String
    let memberPayments: [MemberPaymentDTO]
    let paymentInfo: PaymentInfoDTO
    let shippingInfo: MyShippingInfoDTO
}

struct MemberPaymentDTO: Decodable {
    let memberName: String
    let price: Int
}

struct PaymentInfoDTO: Decodable {
    let shippingFee: Int
    let totalAmount: Int
    let depositStatus: String
    let bank: String?
    let accountNumber: String?
    let depositDeadline: String?
}

struct MyShippingInfoDTO: Decodable {
    let shippingMethod: String
    let receiver: String
    let zipcode: String
    let address: String
    let phone: String
    let carrier: String
    let trackingNumber: String
    let shippingStatus: String
}
