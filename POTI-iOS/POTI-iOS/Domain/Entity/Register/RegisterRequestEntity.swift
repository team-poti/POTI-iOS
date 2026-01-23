//
//  RegisterRequestEntity.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/21/26.
//

import Foundation

public struct RegisterRequestEntity {

    public let artistId: Int
    public let title: String
    public let content: String
    public let deadline: String
    public let bankName: String
    public let accountNumber: String
    public let imageUrls: [String]
    public let options: [Option]
    public let shippings: [Shipping]

    public init(
        artistId: Int,
        title: String,
        content: String,
        deadline: String,
        bankName: String,
        accountNumber: String,
        imageUrls: [String],
        options: [Option],
        shippings: [Shipping]
    ) {
        self.artistId = artistId
        self.title = title
        self.content = content
        self.deadline = deadline
        self.bankName = bankName
        self.accountNumber = accountNumber
        self.imageUrls = imageUrls
        self.options = options
        self.shippings = shippings
    }
}

public extension RegisterRequestEntity {

    struct Option {
        public let memberId: Int
        public let price: Int

        public init(memberId: Int, price: Int) {
            self.memberId = memberId
            self.price = price
        }
    }

    struct Shipping {
        public let deliveryMethodId: Int
        public let price: Int

        public init(deliveryMethodId: Int, price: Int) {
            self.deliveryMethodId = deliveryMethodId
            self.price = price
        }
    }
}
