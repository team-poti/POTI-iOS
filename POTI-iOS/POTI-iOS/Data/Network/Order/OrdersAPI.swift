//
//  OrdersAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import Alamofire

enum OrdersAPI: BaseTargetType {
    case submitOrder(request: OrderRequestDTO)
    
    var path: String {
        switch self {
        case .submitOrder:
            return "/orders"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .submitOrder:
            return .post
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
        }
    }
}
