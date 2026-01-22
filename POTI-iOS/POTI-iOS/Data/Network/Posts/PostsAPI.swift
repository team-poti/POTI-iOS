//
//  PostsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//

import Alamofire

enum PostsAPI: BaseTargetType {
    case fetchManage(postId: Int)
    case fetchSaleDetail(postId: Int)
    
    var path: String {
        switch self {
        case .fetchManage(let postId):
            return "/api/v1/posts/\(postId)/participants"
        case .fetchSaleDetail(let postId):
            return "/api/v1/posts/sale/\(postId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchManage, .fetchSaleDetail:
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
