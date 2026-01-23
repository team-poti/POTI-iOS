//
//  PostPaymentResponseDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

struct PostPaymentResponseDTO: Decodable {
    let paymentId: Int
}

extension PostPaymentResponseDTO {
    func toEntity() -> PostPaymentEntity {
        PostPaymentEntity(paymentId: paymentId)
    }
}
