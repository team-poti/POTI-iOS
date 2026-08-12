//
//  RegisterPostRequestDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

struct RegisterPostRequestDTO: Encodable {
    let artistId: Int
    let title: String
    let content: String
    let deadline: String
    let bankName: String
    let accountNumber: String
    let imageUrls: [String]
    let options: [RegisterPostOptionDTO]
    let shippings: [RegisterPostShippingDTO]

    init(from entity: RegisterPostEntity) {
        artistId = entity.artistId
        title = entity.title
        content = entity.content
        deadline = entity.deadline
        bankName = entity.bankName
        accountNumber = entity.accountNumber
        imageUrls = entity.imageUrls
        options = entity.options.map { .init(memberId: $0.memberId, price: $0.price) }
        shippings = entity.shippings.map { .init(deliveryMethodId: $0.deliveryMethodId, price: $0.price) }
    }
}

struct RegisterPostOptionDTO: Encodable {
    let memberId: Int
    let price: Int
}

struct RegisterPostShippingDTO: Encodable {
    let deliveryMethodId: Int
    let price: Int
}
