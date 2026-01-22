//
//  FeedsAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Alamofire

enum FeedsAPI: BaseTargetType {
    case fetchGoodsList(artistId: Int, sort: String, page: Int)
    
    var path: String {
        return "api/v1/feeds"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        switch self {
            case .fetchGoodsList(let id, let sort, let page):
                var params: [String: String] = [
                    "sort": sort,
                    "page": "\(page)",
                    "size": "10"
                ]
                
                if id != 0 {
                    params["artistId"] = "\(id)"
                }
                
                return params
            }
    }
}

