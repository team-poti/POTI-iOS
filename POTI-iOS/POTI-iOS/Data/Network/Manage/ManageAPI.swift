//
//  ManageAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//

import Alamofire

enum ManageAPI: BaseTargetType {
    case fetchManage(postId: Int)
    
    var path: String {
        switch self {
        case .fetchManage(let postId):
            return "/posts/\(postId)/participants"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchManage:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchManage:
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
