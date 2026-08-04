//
//  CreatePostRequestDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

struct CreatePostRequestDTO: Encodable {
    let artistId: Int
    let title: String
    let content: String
    let deadline: String
    let bankName: String
    let accountNumber: String
    let imageUrls: [String]
    let options: [OptionDTO]
    let shippings: [ShippingDTO]

    struct OptionDTO: Encodable {
        let memberId: Int
        let price: Int
    }

    struct ShippingDTO: Encodable {
        let deliveryMethodId: Int
        let price: Int
    }

    init(from entity: RegisterRequestEntity) {
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
