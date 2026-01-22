//
//  PaymentsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

protocol PaymentsUseCase {
    func execute(orderId: Int) async throws -> RecruitPaymentsConfirmDTO
}

final class DefaultPaymentsUseCase: PaymentsUseCase {
    
    private let repository: PaymentsInterface
    
    init(repository: PaymentsInterface) {
        self.repository = repository
    }
    
    func execute(orderId: Int) async throws -> RecruitPaymentsConfirmDTO {
        return try await repository.patchPaymentConfirm(orderId: orderId)
    }
}
