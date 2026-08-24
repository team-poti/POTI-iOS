//
//  SearchAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import Alamofire

enum SearchAPI: BaseTargetType {
    case searchPosts(keyword: String, page: Int)
    case fetchSuggestions(keyword: String)

    var path: String {
        switch self {
        case .searchPosts:
            return "/api/v1/search"
        case .fetchSuggestions:
            return "/api/v1/search/suggestions"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var queryParameters: [String: String]? {
        switch self {
        case .searchPosts(let keyword, let page):
            return ["keyword": keyword, "page": "\(page)", "size": "10"]
        case .fetchSuggestions(let keyword):
            return ["keyword": keyword]
        }
    }

    var bodyParameters: Parameters? {
        return nil
    }
}
