//
//  OrderInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol OrderInterface {
    func submitOrder(entity: OrderRequestEntity) async throws -> OrderResultEntity
}
