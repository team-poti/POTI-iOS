//
//  PaymentsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import Alamofire

enum PaymentsAPI: BaseTargetType {
    case patchPaymentConfirm(orderId: Int)
    //    case patchTrackingNumberConfirm(
    //        orderId: Int,
    //        carrier: String,
    //        trackingNumber: String
    //    )
    case postPayment(request: PostPaymentRequestDTO)
    
    var path: String {
        switch self {
        case .patchPaymentConfirm(let orderId):
            return "/api/v1/payments/\(orderId)/confirm"
            //        case .patchTrackingNumberConfirm(let orderId, _, _):
            //            return "/api/v1/orders/\(orderId)/deliveries"
        case .postPayment(request: let request):
            return "/api/v1/payments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchPaymentConfirm: //.patchTrackingNumberConfirm
            return .patch
        case .postPayment(request: let request):
            return .post
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .patchPaymentConfirm:
            return nil
            //        case .patchTrackingNumberConfirm(
            //            orderId: _,
            //            carrier: let carrier,
            //            trackingNumber: let trackingNumber):
            //            return [
            //                "carrier": carrier,
            //                "trackingNumber": trackingNumber
            //            ]
        case .postPayment(let request):
            return request.toParameters()
        }
    }
}
