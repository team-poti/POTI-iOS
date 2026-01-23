//
//  PostPaymentDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Alamofire

struct PostPaymentRequestDTO: Encodable {
    let participationId: Int
    let depositorName: String
    let depositedAt: String
    
    // 수상하다 요놈 비어있음!!!!!!
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
