//
//  PotModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

struct ParticipantManageModel {
    //서버 응답 보고 대략 만들어놨는데 이번에 쓰진 않았습니다!!
    lazy var totalCount: Int = items.count
    var items: [ParticipantModel] = []
}

struct ParticipantModel: Hashable {
    let purchaseId: Int
    let memberNamesText: [String]
    let depositorNameText: String
    let addressText: String
    let phoneText: String
    let shippingText: String
    let totalPrice: Int
    let depositStateText: ParticipantStatus
}
