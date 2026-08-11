//
//  ProductFormAction.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

import UIKit

enum ProductFormAction {
    case artistFieldTapped
    case deadlineFieldTapped
    case inputFocused(UIView)
    case productTypeChanged(String)
    case descriptionChanged(String)
    case accountNumberChanged(String)
    case bankChanged(String)
}
