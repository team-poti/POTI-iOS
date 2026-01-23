//
//  ParticipationsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Alamofire

enum ParticipationsAPI: BaseTargetType {
    case fetchParticipation(participationId: Int)
    case patchParticipationDelivered(participationId: Int)
    
    var path: String {
        switch self {
        case .fetchParticipation(let participationId):
            return "/api/v1/participations/\(participationId)"
        case .patchParticipationDelivered(let participationId):
            return "/api/v1/participations/\(participationId)/delivered"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchParticipation:
            return .get
        case .patchParticipationDelivered:
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
