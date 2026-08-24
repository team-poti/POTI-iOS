//
//  ProductRegisterAction.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

enum ProductRegisterAction {
    case addImage
    case deleteImage(Int)
    case form(ProductFormAction)
    case memberSetting(MemberSettingAction)
    case shippingSetting(ShippingSettingAction)
    case submit
}
