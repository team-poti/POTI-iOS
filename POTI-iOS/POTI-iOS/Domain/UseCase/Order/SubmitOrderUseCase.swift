//
//  SubmitOrderUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol SubmitOrderUseCase {
    func execute(orderInfo: OrderRequestEntity) async throws -> OrderResultEntity
}

final class DefaultSubmitOrderUseCase: SubmitOrderUseCase {
    private let repository: OrderInterface
    
    init(repository: OrderInterface) {
        self.repository = repository
    }
    
    func execute(orderInfo: OrderRequestEntity) async throws -> OrderResultEntity {
        return try await repository.submitOrder(entity: orderInfo)
    }
}
