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
    case fetchPotDetail(postId: Int)
    case fetchPotOptions(postId: Int)
    
    var path: String {
        switch self {
        case .fetchManage(let postId):
            return "/api/v1/posts/\(postId)/participants"
        case .fetchSaleDetail(let postId):
            return "/api/v1/posts/sale/\(postId)"
        case .fetchMyPostsHistory:
            return "/api/v1/posts/me"
        case .fetchPotDetail(let postId):
            return "/api/v1/posts/\(postId)"
        case .fetchPotOptions(postId: let postId):
            return "/api/v1/posts/\(postId)/options"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchManage, .fetchSaleDetail, .fetchMyPostsHistory, .fetchPotDetail, .fetchPotOptions:
            return .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchManage, .fetchSaleDetail, .fetchPotDetail, .fetchPotOptions:
            return nil
        case .fetchMyPostsHistory(let status):
            return ["status": status]
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
