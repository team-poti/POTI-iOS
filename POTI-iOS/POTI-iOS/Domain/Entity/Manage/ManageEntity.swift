//
//  ManageEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/17/26.
//

struct ManageEntity: Hashable {
    let participants: [ParticipantEntity]
}

struct ParticipantEntity: Hashable {
    let orderId: Int
    let userId: Int
    let profileImage: String?
    let nickname: String
    let memberNames: [String]
    let status: ParticipantStatus

    let priceInfo: PriceInfoEntity
    let depositInfo: DepositInfoEntity?
    let shippingInfo: ShippingInfoEntity?
}

struct PriceInfoEntity: Hashable {
    let memberPerPrices: [MemberPerPriceEntity]
    let shippingName: String
    let shippingPrice: Int
    let totalPrice: Int
}

struct MemberPerPriceEntity: Hashable {
    let name: String
    let price: Int
}

struct DepositInfoEntity: Hashable {
    let depositorName: String
    let depositTime: String
}

struct ShippingInfoEntity: Hashable {
    let receiverName: String
    let address: String
    let phone: String
    let trackingNumber: String?
}
