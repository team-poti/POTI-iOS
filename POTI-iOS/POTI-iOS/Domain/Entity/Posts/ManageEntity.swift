//
//  ManageEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/17/26.
//

struct ManageEntity {
    let participants: [ParticipantEntity]
}

struct ParticipantEntity {
    let orderId: Int
    let userId: Int
    let profileImage: String?
    let nickname: String
    let memberNames: [String]
    let status: ParticipantOrderStatus

    let priceInfo: PriceInfoEntity
    let depositInfo: DepositInfoEntity?
    let shippingInfo: ShippingInfoEntity?
}

struct PriceInfoEntity {
    let memberPerPrices: [MemberPerPriceEntity]
    let shippingName: String
    let shippingPrice: Int
    let totalPrice: Int
}

struct MemberPerPriceEntity {
    let name: String
    let price: Int
}

struct DepositInfoEntity {
    let depositorName: String
    let depositTime: String
}

struct ShippingInfoEntity {
    let receiverName: String
    let address: String
    let phone: String
    let trackingNumber: String?
}

extension ManageEntity {
    func toParticipantManageModels() -> [ParticipantManageModel] {
        participants.map { $0.toParticipantManageModel() }
    }
}
