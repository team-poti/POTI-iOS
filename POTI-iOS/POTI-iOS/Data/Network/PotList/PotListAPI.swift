//
//  PotListAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import Alamofire

enum PotListAPI: BaseTargetType {
    case fetchPotList
    
    var path: String {
        switch self {
        case .fetchPotList:
            return "/posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPotList:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchPotList:
            return .basic
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}


