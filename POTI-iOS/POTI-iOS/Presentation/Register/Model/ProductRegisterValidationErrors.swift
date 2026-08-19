//
//  ProductRegisterValidationErrors.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

enum MemberSettingValidationError: Equatable {
    case noSelectedMember
    case missingPrice

    var message: String {
        switch self {
        case .noSelectedMember:
            return "멤버를 1명 이상 추가해주세요"
        case .missingPrice:
            return "모든 멤버에 가격을 설정해주세요"
        }
    }
}

enum ShippingSettingValidationError: Equatable {
    case noSelectedOption
    case missingPrice

    var message: String {
        switch self {
        case .noSelectedOption:
            return "배송 방법을 1개 이상 선택해주세요"
        case .missingPrice:
            return "선택한 배송 방법의 가격을 설정해주세요"
        }
    }
}

struct ProductRegisterValidationErrors {
    var images: String?
    var productForm = ProductFormValidationErrors()
    var members: MemberSettingValidationError?
    var shipping: ShippingSettingValidationError?

    var hasError: Bool {
        images != nil || productForm.hasError || members != nil || shipping != nil
    }
}
