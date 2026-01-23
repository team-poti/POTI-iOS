//
//  ParticipationsAPI.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import Alamofire

enum ParticipationsAPI: BaseTargetType {
    case fetchMyParticipationsHistory(status: String)
    
    var path: String {
        switch self {
        case .fetchMyParticipationsHistory:
            return "/api/v1/participations"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyParticipationsHistory:
            return .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchMyParticipationsHistory(let status):
            return ["status": status]
        }
    }
}
