//
//  PaymentsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import Alamofire

enum PaymentsAPI: BaseTargetType {
    case patchPaymentConfirm(orderId: Int)
    case postPayment(request: PostPaymentRequestDTO)
    
    var path: String {
        switch self {
        case .patchPaymentConfirm(let orderId):
            return "/api/v1/payments/\(orderId)/confirm"
        case .postPayment:
            return "/api/v1/payments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchPaymentConfirm: //.patchTrackingNumberConfirm
            return .patch
        case .postPayment:
            return .post
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .patchPaymentConfirm:
            return nil
        case .postPayment(let request):
            return [
                "orderId": request.participationId,
                "depositorName": request.depositorName,
                "depositedAt": request.depositedAt
            ]
        }
    }
}
