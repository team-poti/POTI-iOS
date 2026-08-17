//
//  TrackingNumberResponseDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct TrackingNumberResponseDTO: Decodable {
    let orderId: Int
    let status: String
    let trackingNumber: String
    let shippedAt: String
}

extension TrackingNumberResponseDTO {
    func toEntity() -> TrackingNumberResponseEntity {
        TrackingNumberResponseEntity(
            orderId: orderId,
            status: status,
            trackingNumber: trackingNumber,
            shippedAt: shippedAt
        )
    }
}
