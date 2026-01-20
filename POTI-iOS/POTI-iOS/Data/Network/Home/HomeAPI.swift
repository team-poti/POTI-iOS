//
//  HomeAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Alamofire

enum HomeAPI: BaseTargetType {
    case fetchHome
    
    var path: String {
        switch self {
        case .fetchHome:
            return "/home"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHome:
            return .get
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
