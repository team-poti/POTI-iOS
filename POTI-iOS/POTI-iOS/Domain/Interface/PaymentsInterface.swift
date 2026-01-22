//
//  PaymentsInterface.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

protocol PaymentsInterface {
    func patchPaymentConfirm(orderId: Int) async throws -> RecruitPaymentsConfirmDTO
}
