//
//  RegisterRequestDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

import Foundation


struct RegisterRequestDTO: Encodable {

    let artistId: Int64
    let title: String
    let content: String

    /// yyyy-MM-dd
    let deadline: String

    let bankName: String
    let accountNumber: String

    /// presigned 업로드 후 받은 S3 key 리스트
    let imageUrls: [String]

    let options: [OptionDTO]
    let shippings: [ShippingDTO]

    struct OptionDTO: Encodable {
        let memberId: Int64
        let price: Int
    }

    struct ShippingDTO: Encodable {
        let deliveryMethodId: Int64
        let price: Int
    }
}

// MARK: - Entity Mapping

extension RegisterRequestDTO {

    init(from entity: RegisterRequestEntity) {
        self.artistId = entity.artistId
        self.title = entity.title
        self.content = entity.content
        self.deadline = entity.deadline
        self.bankName = entity.bankName
        self.accountNumber = entity.accountNumber
        self.imageUrls = entity.imageUrls
        self.options = entity.options.map { .init(memberId: $0.memberId, price: $0.price) }
        self.shippings = entity.shippings.map { .init(deliveryMethodId: $0.deliveryMethodId, price: $0.price) }
    }
}

extension RegisterRequestDTO {

    func toParameters() -> [String: Any] {
        return [
            "artistId": artistId,
            "title": title,
            "content": content,
            "deadline": deadline,
            "bankName": bankName,
            "accountNumber": accountNumber,
            "imageUrls": imageUrls,
            "options": options.map { ["memberId": $0.memberId, "price": $0.price] },
            "shippings": shippings.map { ["deliveryMethodId": $0.deliveryMethodId, "price": $0.price] }
        ]
    }
}
