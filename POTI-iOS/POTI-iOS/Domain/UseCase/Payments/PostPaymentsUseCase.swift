//
//  PostPaymentsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol PostPaymentsUseCase {
    func execute(entity: PostPaymentEntity) async throws -> PostPaymentResponseEntity
}

final class DefaultPostPaymentsUseCase: PostPaymentsUseCase {
    private let repository: PaymentsInterface
    
    init(repository: PaymentsInterface) {
        self.repository = repository
    }
    
    func execute(entity: PostPaymentEntity) async throws -> PostPaymentResponseEntity {
        return try await repository.postPaymentConfirm(entity: entity)
    }
}
