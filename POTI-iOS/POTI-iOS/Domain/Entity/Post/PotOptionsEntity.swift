//
//  PotOptionsEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

struct PotOptionsEntity {
    let members: [MemberEntity]
    let shippings: [ShippingEntity]
}

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


