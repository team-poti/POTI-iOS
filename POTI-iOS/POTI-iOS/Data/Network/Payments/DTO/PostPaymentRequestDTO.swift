//
//  PostPaymentDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Alamofire

struct PostPaymentRequestDTO: Encodable {
    let orderId: Int
    let depositorName: String
    let depositedAt: String
}

extension PostPaymentRequestDTO {
    func toParameters() -> Parameters {
        [
            "orderId": orderId,
            "depositorName": depositorName,
            "depositedAt": depositedAt
        ]
    }
}
