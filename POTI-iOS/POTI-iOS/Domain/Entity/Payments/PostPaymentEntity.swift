//
//  PostPaymentEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

struct PostPaymentEntity {
    let participationId: Int
    let depositorName: String
    let depositedAt: String
}

struct PostPaymentResponseEntity {
    let paymentId: Int
}
