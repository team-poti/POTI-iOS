//
//  OrdersDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct OrdersDTO: Codable {
    let groupBuyPostId: Int
    let shippingId: Int
    let deliveryInfo: DeliveryInfoDTO
    let items: [OrderItemDTO]
    
    func toEntity() -> OrdersEntity {
        return OrdersEntity(
            postId: groupBuyPostId,
            shippingId: shippingId,
            receiverName: deliveryInfo.receiverName,
            zipcode: deliveryInfo.zipcode,
            addressLine: deliveryInfo.addressLine,
            phone: deliveryInfo.phone,
            items: items.map { $0.toEntity() }
        )
    }
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
    
    func toEntity() -> OrderItem {
        return OrderItem(
            optionId: groupBuyOptionId,
            count: count
        )
    }
}

struct OrderResponseDTO: Codable {
    let participationId: Int
    
    func toOrderResponseEntity() -> OrderResponseEntity {
        return OrderResponseEntity(participationId: self.participationId)
    }
}
