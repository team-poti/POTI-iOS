//
//  ParticipationOptionResult.swift
//  POTI-iOS
//
//  Created by soomin on 7/28/26.
//

struct ParticipationOptionResult {
    let shippingId: Int
    let orderItems: [ParticipationItem]
    let shippingInfo: (name: String, price: Int)
    let memberInfos: [(name: String, price: Int)]
}
