//
//  DefaultRegisterShippingOptions.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

enum DefaultRegisterShippingOptions {
    static let items = [
        RegisterShippingOptionItem(deliveryMethodID: 1, name: "일반택배", price: 4000, isSelected: false),
        RegisterShippingOptionItem(deliveryMethodID: 2, name: "준등기", price: 1800, isSelected: false),
        RegisterShippingOptionItem(deliveryMethodID: 3, name: "GS 반값택배", price: 1900, isSelected: false),
        RegisterShippingOptionItem(deliveryMethodID: 4, name: "CU 알뜰택배", price: 1800, isSelected: false)
    ]
}
