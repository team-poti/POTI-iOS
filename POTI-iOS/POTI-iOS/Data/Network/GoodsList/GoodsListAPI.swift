//
//  GoodsListAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Alamofire

enum GoodsListAPI: BaseTargetType {
    case fetchGoodsList
    
    var path: String {
        switch self {
        case .fetchGoodsList:
            return "/posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchGoodsList:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchGoodsList:
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

