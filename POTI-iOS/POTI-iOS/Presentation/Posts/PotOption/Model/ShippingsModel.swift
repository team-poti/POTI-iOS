//
//  ShippingsModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

struct ShippingModel {
    let deliveryOptionId: Int
    let deliveryName: String
    let deliveryOptionPrice: Int
}

let mockShippings: [ShippingModel] = .init([
    .init(deliveryOptionId: 1, deliveryName: "일반 택배", deliveryOptionPrice: 2500),
    .init(deliveryOptionId: 2, deliveryName: "GS 반택", deliveryOptionPrice: 3000),
    .init(deliveryOptionId: 1, deliveryName: "우체국 택배", deliveryOptionPrice: 1500)
])
