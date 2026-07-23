//
//  PotOptionsDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/23/26.
//

struct PotOptionsDTO: Decodable {
    let members: [MemberDTO]
    let shippings: [ShippingDTO]
    
    func toEntity() -> PotOptionsEntity {
        return PotOptionsEntity(
            members: members.map { $0.toEntity() },
            shippings: shippings.map { $0.toEntity() }
        )
    }
}

struct MemberDTO: Decodable {
    let memberOptionId: Int
    let memberName: String
    let memberOptionPrice: Int
    
    func toEntity() -> MemberEntity {
        return MemberEntity(
            id: memberOptionId,
            name: memberName,
            price: memberOptionPrice
        )
    }
}

struct ShippingDTO: Decodable {
    let deliveryOptionId: Int
    let deliveryName: String
    let deliveryOptionPrice: Int
    
    func toEntity() -> ShippingEntity {
        return ShippingEntity(
            id: deliveryOptionId,
            name: deliveryName,
            price: deliveryOptionPrice
        )
    }
}
