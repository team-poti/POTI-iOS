//
//  OrderInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

protocol OrderInterface {
    func fetchOrderOptions() async throws -> OrderEntity
}
