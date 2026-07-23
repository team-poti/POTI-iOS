//
//  OrdersDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct ParticipationRequestDTO: Encodable {
    let groupBuyPostId: Int
    let shippingId: Int
    let deliveryInfo: DeliveryInfoDTO
    let items: [ParticipationItemDTO]
    
    func toEntity() -> ParticipationEntity {
        return ParticipationEntity(
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

struct ParticipationItemDTO: Codable {
    let groupBuyOptionId: Int
    let count: Int
    
    func toEntity() -> ParticipationItem {
        return ParticipationItem(
            optionId: groupBuyOptionId,
            count: count
        )
    }
}

struct ParticipationResponseDTO: Decodable {
    let participationId: Int
    
    func toEntity() -> ParticipationResponseEntity {
        return ParticipationResponseEntity(participationId: self.participationId)
    }
}
