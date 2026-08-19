//
//  ShippingSettingAction.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

enum ShippingSettingAction {
    case selectionToggled(deliveryMethodID: Int)
    case priceChanged(deliveryMethodID: Int, price: Int?)
}
