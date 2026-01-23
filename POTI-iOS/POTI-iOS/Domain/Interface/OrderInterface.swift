//
//  OrderInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol OrderInterface {
    func submitOrder(entity: OrdersEntity) async throws -> OrderResponseEntity
    
    func patchTrackingNumber(
        orderId: Int,
        entity: TrackingNumberRequestEntity
    ) async throws -> TrackingNumberResponseEntity
}
