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
    case fetchMyPostsHistory(status: String)
    
    var path: String {
        switch self {
        case .fetchManage(let postId):
            return "/api/v1/posts/\(postId)/participants"
        case .fetchSaleDetail(let postId):
            return "/api/v1/posts/sale/\(postId)"
        case .fetchMyPostsHistory:
            return "/api/v1/posts/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchManage, .fetchSaleDetail, .fetchMyPostsHistory:
            return .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchManage, .fetchSaleDetail:
            return nil
        case .fetchMyPostsHistory(let status):
            return ["status": status]
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
