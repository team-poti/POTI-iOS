//
//  OrdersEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct OrdersEntity {
    let postId: Int
    let shippingId: Int
    let receiverName: String
    let zipcode: String
    let addressLine: String
    let phone: String
    let items: [OrderItem]
}

struct OrderItem {
    let optionId: Int
    let count: Int
}

struct OrderResponseEntity {
    let participationId: Int
}
