//
//  PotiTextFieldType.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

enum TextFieldVariant {
    case editable
    case characterLimited(maxLength: Int)
    case readOnly(accessory: TextFieldAccessory)
}

enum TextFieldAccessory {
    case none
    case search
}

enum TextFieldValidationState: Equatable {
    case normal
    case error(message: String)
}
