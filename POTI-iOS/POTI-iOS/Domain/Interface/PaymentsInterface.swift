//
//  PaymentsInterface.swift
//  POTI-iOS
//
//  Created by Neon on 1/22/26.
//

protocol PaymentsInterface {
    func patchPaymentConfirm(orderId: Int) async throws -> PaymentsConfirmEntity
    
    func postPaymentConfirm(entity: PostPaymentEntity) async throws -> PostPaymentResponseEntity
}
