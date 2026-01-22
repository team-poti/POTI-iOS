//
//  PotListAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import Alamofire

enum PotListAPI: BaseTargetType {
    case fetchPotList(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int)
    
    var path: String {
        switch self {
        case .fetchPotList:
            return "api/v1/posts/pots"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .fetchPotList(let title, let artistId, let memberIds, let sort, let page):
            var params: [String: String] = [
                "title": title,
                "artistId": "\(artistId)",
                "sort": sort,
                "page": "\(page)",
                "size": "10"
            ]
            
            if let ids = memberIds, !ids.isEmpty {
                params["memberIds"] = ids.map { String($0) }.joined(separator: ",")
            }
            return params
        }
    }
}


