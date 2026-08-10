//
//  ProductRegisterValidationErrors.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

struct ProductRegisterValidationErrors {
    var images: String?
    var productForm = ProductFormValidationErrors()
    var members: String?

    var hasError: Bool {
        images != nil || productForm.hasError || members != nil
    }
}
