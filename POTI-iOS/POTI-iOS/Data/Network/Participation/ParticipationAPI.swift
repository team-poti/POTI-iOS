//
//  ParticipationAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 6/11/26.
//

import Alamofire

enum ParticipationAPI: BaseTargetType {
    case applyParticipation(request: ParticipationRequestDTO)
    case fetchParticipationsDetail(participationId: Int)
    case patchParticipationDelivered(participationId: Int)

    var path: String {
        switch self {
        case .applyParticipation:
            return "/api/v1/orders"

        case .fetchParticipationsDetail(let participationId):
            return "/api/v1/participations/\(participationId)"

        case .patchParticipationDelivered(let participationId):
            return "/api/v1/participations/\(participationId)/delivered"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .applyParticipation:
            return .post
        case .fetchParticipationsDetail:
            return .get
        case .patchParticipationDelivered:
            return .patch
        }
    }

    var queryParameters: [String: String]? {
        return nil
    }

    var bodyParameters: Parameters? {
        switch self {
        case .applyParticipation(let request):
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

        case .fetchParticipationsDetail, .patchParticipationDelivered:
            return nil
        }
    }
}
