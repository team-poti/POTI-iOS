//
//  PaymentsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

protocol PaymentsConfirmUseCase {
    func execute(orderId: Int) async throws -> RecruitPaymentsConfirmDTO
}

final class DefaultPaymentsUseCase: PaymentsConfirmUseCase {
    
    private let repository: PaymentsInterface
    
    init(repository: PaymentsInterface) {
        self.repository = repository
    }
    
    func execute(orderId: Int) async throws -> RecruitPaymentsConfirmDTO {
        return try await repository.patchPaymentConfirm(orderId: orderId)
    }
}
