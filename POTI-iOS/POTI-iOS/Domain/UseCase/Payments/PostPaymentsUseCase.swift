//
//  PostPaymentsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol PostPaymentsUseCase {
    func execute(orderId: Int, depositorName: String, depositedAt: String) async throws -> PostPaymentEntity
}

final class DefaultPostPaymentsUseCase: PostPaymentsUseCase {
    private let repository: PaymentsInterface
    
    init(repository: PaymentsInterface) {
        self.repository = repository
    }
    
    func execute(orderId: Int, depositorName: String, depositedAt: String) async throws -> PostPaymentEntity {
        try await repository.postPaymentConfirm(
            orderId: orderId,
            depositorName: depositorName,
            depositedAt: depositedAt
        )
    }
    
}

