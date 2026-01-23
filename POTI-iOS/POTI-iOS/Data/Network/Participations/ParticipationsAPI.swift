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
    case fetchMyParticipationsHistory(status: String)
    
    var path: String {
        switch self {
        case .fetchParticipation(let participationId):
            return "/api/v1/participations/\(participationId)"
        case .patchParticipationDelivered(let participationId):
            return "/api/v1/participations/\(participationId)/delivered"
        case .fetchMyParticipationsHistory:
            return "/api/v1/participations"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchParticipation:
            return .get
        case .patchParticipationDelivered:
            return .patch
        case .fetchMyParticipationsHistory:
            return .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchMyParticipationsHistory(let status):
            return ["status": status]
        case .fetchParticipation, .patchParticipationDelivered:
            return nil
        }
    }
}
