//
//  ShippingSettingViewState.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

struct RegisterShippingOptionItem: Equatable {
    let deliveryMethodID: Int
    let name: String
    var price: Int?
    var isSelected: Bool
}

struct ShippingSettingViewState: Equatable {
    let options: [RegisterShippingOptionItem]
    let error: ShippingSettingValidationError?
}
