//
//  OrderRequestDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct OrderRequestDTO: Codable {
    let groupBuyPostId: Int
    let shippingId: Int
    let deliveryInfo: DeliveryInfoDTO
    let items: [OrderItemDTO]
}

struct DeliveryInfoDTO: Codable {
    let receiverName: String
    let zipcode: String
    let addressLine: String
    let phone: String
}

struct OrderItemDTO: Codable {
    let groupBuyOptionId: Int
    let count: Int
}
