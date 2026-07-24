//
//  OrderManagementAPI.swift
//  POTI-iOS
//
//  Created by soomin on 6/11/26.
//

import Alamofire

enum OrderManagementAPI: BaseTargetType {
    case patchTrackingNumber(orderId: Int, request: TrackingNumberRequestDTO)
    case fetchManage(postId: Int)
    case fetchSaleDetail(postId: Int)

    var path: String {
        switch self {
        case .patchTrackingNumber(let orderId, _):
            return "/api/v1/orders/\(orderId)/deliveries"
        case .fetchManage(let postId):
            return "/api/v1/posts/\(postId)/participants"
        case .fetchSaleDetail(let postId):
            return "/api/v1/posts/sale/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .patchTrackingNumber:
            return .patch
        case .fetchManage, .fetchSaleDetail:
            return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .patchTrackingNumber, .fetchManage, .fetchSaleDetail:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .patchTrackingNumber(_, let request):
            return [
                "carrier": request.carrier,
                "trackingNumber": request.trackingNumber
            ]
        case .fetchManage, .fetchSaleDetail:
            return nil
        }
    }
}
