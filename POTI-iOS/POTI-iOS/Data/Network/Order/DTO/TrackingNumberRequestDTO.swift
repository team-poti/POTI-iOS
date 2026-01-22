//
//  TrackingNumberRequestDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct TrackingNumberRequestDTO: Encodable {
    let carrier: String
    let trackingNumber: String
}

extension TrackingNumberRequestDTO {
    func toEntity() -> TrackingNumberRequestEntity {
        TrackingNumberRequestEntity(
            carrier: carrier,
            trackingNumber: trackingNumber
        )
    }
}
