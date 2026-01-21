//
//  OrderEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

struct MemberEntity {
    let id: Int
    let name: String
    let price: Int
}

struct ShippingEntity {
    let id: Int
    let name: String
    let price: Int
}

struct OrderEntity {
    let members: [MemberEntity]
    let shippings: [ShippingEntity]
}
