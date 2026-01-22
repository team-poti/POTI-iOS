//
//  ParticipantManageModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/20/26.
//

struct ParticipantModel: Hashable {
    let purchaseId: Int
    let memberNamesText: [String]
    let depositorNameText: String
    let addressText: String
    let phoneText: String
    let shippingText: String
    let totalPrice: Int
    let depositStateText: ParticipantOrderStatus
}
