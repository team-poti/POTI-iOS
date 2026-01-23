//
//  PostPaymentResponseDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

struct PostPaymentResponseDTO: Decodable {
    let paymentId: Int
    
    func toPostPaymentResponseEntity() -> PostPaymentResponseEntity {
        return PostPaymentResponseEntity(paymentId: paymentId)
    }
}
