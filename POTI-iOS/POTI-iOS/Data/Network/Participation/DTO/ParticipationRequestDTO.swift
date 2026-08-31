//
//  OrdersDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

struct ParticipationRequestDTO: Encodable {
    let groupBuyPostId: Int
    let shippingId: Int
    let deliveryInfo: DeliveryInfoDTO
    let items: [ParticipationItemDTO]

    init(from entity: ParticipationEntity) {
        groupBuyPostId = entity.postId
        shippingId = entity.shippingId
        deliveryInfo = DeliveryInfoDTO(
            receiverName: entity.receiverName,
            zipcode: entity.zipcode,
            address: entity.address,
            addressDetail: entity.addressDetail,
            phone: entity.phone
        )
        items = entity.items.map {
            .init(groupBuyOptionId: $0.optionId, count: $0.count)
        }
    }
}

struct DeliveryInfoDTO: Encodable {
    let receiverName: String
    let zipcode: String
    let address: String
    let addressDetail: String
    let phone: String
}

struct ParticipationItemDTO: Encodable {
    let groupBuyOptionId: Int
    let count: Int
}

struct ParticipationResponseDTO: Decodable {
    let participationId: Int
    
    func toEntity() -> ParticipationResponseEntity {
        return ParticipationResponseEntity(participationId: self.participationId)
    }
}
