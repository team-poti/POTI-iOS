//
//  OrdersDeliveriesUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//


protocol OrdersDeliveriesUseCase {
    func execute(orderId: Int, entity: TrackingNumberRequestEntity) async throws -> TrackingNumberResponseEntity
}

final class DefaultOrdersDeliveriesUseCase: OrdersDeliveriesUseCase {
    
    private let repository: OrderInterface
    
    init(repository: OrderInterface) {
        self.repository = repository
    }
    
    func execute(
        orderId: Int,
        entity: TrackingNumberRequestEntity
    ) async throws -> TrackingNumberResponseEntity {
        return try await repository.patchTrackingNumber(orderId: orderId, entity: entity)
    }
}
