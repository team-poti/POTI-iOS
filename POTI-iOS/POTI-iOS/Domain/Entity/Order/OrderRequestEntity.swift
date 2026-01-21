//
//  OrderRequestEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct OrderRequestEntity {
    let postId: Int
    let shippingId: Int
    let receiverName: String
    let zipcode: String
    let addressLine: String
    let phone: String
    let items: [OrderOptionItem]
}

struct OrderOptionItem {
    let optionId: Int
    let count: Int
}
