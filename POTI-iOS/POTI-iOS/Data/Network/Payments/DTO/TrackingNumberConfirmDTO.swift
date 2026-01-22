//
//  TrackingNumberConfirmDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct TrackingNumberConfirmDTO: Decodable {
    let orderId: Int
    let status: String
    let trackingNumber: String
    let shippedAt: String
}
