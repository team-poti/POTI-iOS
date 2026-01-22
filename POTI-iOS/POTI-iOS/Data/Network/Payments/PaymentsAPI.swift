//
//  PaymentsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import Alamofire

enum PaymentsAPI: BaseTargetType {
    case patchPaymentConfirm(orderId: Int)

    var path: String {
        switch self {
        case .patchPaymentConfirm(let orderId):
            return "/api/v1/payments/\(orderId)/confirm"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchPaymentConfirm(let orderId):
            return .patch
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
