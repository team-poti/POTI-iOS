//
//  PostPaymentDTO.swift
//  POTI-iOS
//
//  Created by Neon on 1/23/26.
//

import Alamofire

struct PostPaymentRequestDTO: Encodable {
    let participationId: Int
    let depositorName: String
    let depositedAt: String
    
    enum CodingKeys: String, CodingKey {
        case participationId = "orderId"
        case depositorName
        case depositedAt
    }
    
    func toEntity() -> PostPaymentEntity {
        return PostPaymentEntity(participationId: participationId, depositorName: depositorName, depositedAt: depositedAt
        )
    }
}
