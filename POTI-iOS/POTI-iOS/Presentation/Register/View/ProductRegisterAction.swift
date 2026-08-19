//
//  ProductRegisterAction.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

import UIKit

enum ProductRegisterAction {
    case addImage
    case deleteImage(Int)
    case form(ProductFormAction)
    case inputFocused(UIView)
    case memberSetting(MemberSettingAction)
    case shippingSetting(ShippingSettingAction)
    case submit
}
