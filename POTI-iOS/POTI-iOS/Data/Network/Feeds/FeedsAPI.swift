//
//  FeedsAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Alamofire

enum FeedsAPI: BaseTargetType {
    case fetchFeeds(artistId: Int?, sort: FeedsSortOption, page: Int)
    
    var path: String {
        return "api/v1/feeds"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchFeeds(let artistId, let sort, let page):
            var params: [String: String] = [
                "sort": sort.rawValue,
                "page": "\(page)",
                "size": "10"
            ]
            
            if let id = artistId, id != 0 {
                params["artistId"] = "\(id)"
            }
            
            return params
        }
    }
}

