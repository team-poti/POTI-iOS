//
//  ParticipationsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Alamofire

enum ParticipationsAPI: BaseTargetType {
    case fetchParticipation(participationId: Int)
    
    var path: String {
        switch self {
        case .fetchParticipation(let participationId):
            return "/api/v1/participations/\(participationId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchParticipation:
            return .get
        }
    }
//    
//    var queryParameters: Parameters? {
//        return nil
//    }
//    
//    var bodyParameters: Parameters? {
//        return nil
//    }
}
