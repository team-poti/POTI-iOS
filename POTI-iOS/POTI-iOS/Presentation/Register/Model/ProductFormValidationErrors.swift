//
//  ProductFormValidationErrors.swift
//  POTI-iOS
//
//  Created by soomin on 8/8/26.
//

struct ProductFormValidationErrors {
    var artist: String?
    var productType: String?
    var deadline: String?
    var description: String?
    var accountNumber: String?
    var bank: String?

    var hasError: Bool {
        artist != nil || productType != nil || deadline != nil || description != nil || accountNumber != nil || bank != nil
    }
}
