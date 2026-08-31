//
//  PaymentsUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 1/22/26.
//

protocol PaymentsConfirmUseCase {
    func execute(orderId: Int) async throws -> PaymentsConfirmEntity
}

final class DefaultPaymentsUseCase: PaymentsConfirmUseCase {
    
    private let repository: PaymentsInterface
    
    init(repository: PaymentsInterface) {
        self.repository = repository
    }
    
    func execute(orderId: Int) async throws -> PaymentsConfirmEntity {
        return try await repository.patchPaymentConfirm(orderId: orderId)
    }
}
