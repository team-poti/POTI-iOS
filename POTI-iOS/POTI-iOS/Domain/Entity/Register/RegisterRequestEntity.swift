//
//  RegisterRequestEntity.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/21/26.
//

import Foundation

public struct RegisterRequestEntity {

    public let artistId: Int64
    public let title: String
    public let content: String

    /// yyyy-MM-dd 형식으로 전송
    public let deadline: String

    public let bankName: String
    public let accountNumber: String

    /// presigned 업로드 후 받은 S3 리스트
    public let imageUrls: [String]

    /// 선택된 멤버 리스트
    public let options: [Option]

    /// 배송 옵션 리스트
    public let shippings: [Shipping]

    public init(
        artistId: Int64,
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
        public let memberId: Int64
        public let price: Int

        public init(memberId: Int64, price: Int) {
            self.memberId = memberId
            self.price = price
        }
    }

    struct Shipping {
        public let deliveryMethodId: Int64
        public let price: Int

        public init(deliveryMethodId: Int64, price: Int) {
            self.deliveryMethodId = deliveryMethodId
            self.price = price
        }
    }
}
