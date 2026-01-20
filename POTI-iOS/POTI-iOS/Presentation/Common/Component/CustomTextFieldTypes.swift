//
//  CustomTextFieldTypes.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import Foundation

enum TextFieldVariant {
    case short
    case count(max: Int)
    case searchNavigate
}

enum TextFieldUIState: Equatable {
    case normal
    case focused
    case error(String)
}
