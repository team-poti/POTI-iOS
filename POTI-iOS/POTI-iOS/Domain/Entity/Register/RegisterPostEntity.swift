//
//  RegisterPostEntity.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

struct RegisterPostEntity {
    let artistId: Int
    let title: String
    let content: String
    let deadline: String
    let bankName: String
    let accountNumber: String
    let imageUrls: [String]
    let options: [RegisterPostOptionEntity]
    let shippings: [RegisterPostShippingEntity]
}

struct RegisterPostOptionEntity {
    let memberId: Int
    let price: Int
}

struct RegisterPostShippingEntity {
    let deliveryMethodId: Int
    let price: Int
}
