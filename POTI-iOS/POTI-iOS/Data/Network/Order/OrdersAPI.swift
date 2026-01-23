//
//  OrdersAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import Alamofire

enum OrdersAPI: BaseTargetType {
    case submitOrder(request: OrdersDTO)
    case patchTrackingNumber(
        orderId: Int,
        request: TrackingNumberRequestDTO)
    
    var path: String {
        switch self {
        case .submitOrder:
            return "/api/v1/orders"
        case .patchTrackingNumber(let orderId, _):
            return "/api/v1/orders/\(orderId)/deliveries"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .submitOrder:
            return .post
        case .patchTrackingNumber:
            return .patch
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .submitOrder(let request):
            return [
                "groupBuyPostId": request.groupBuyPostId,
                "shippingId": request.shippingId,
                "deliveryInfo": [
                    "receiverName": request.deliveryInfo.receiverName,
                    "zipcode": request.deliveryInfo.zipcode,
                    "addressLine": request.deliveryInfo.addressLine,
                    "phone": request.deliveryInfo.phone
                ],
                "items": request.items.map { [
                    "groupBuyOptionId": $0.groupBuyOptionId,
                    "count": $0.count
                ]}
            ]
        case .patchTrackingNumber(let orderId, let request):
            return [
                "carrier": request.carrier,
                "trackingNumber": request.trackingNumber
            ]
        }
    }
}
