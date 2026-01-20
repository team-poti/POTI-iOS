//
//  OrderUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

protocol OrderUseCase {
    func execute() async throws -> OrderEntity
}

final class DefaultOrderUseCase: OrderUseCase {
    private let repository: OrderInterface
    
    init(repository: OrderInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> OrderEntity {
        return try await repository.fetchOrderOptions()
    }
}
