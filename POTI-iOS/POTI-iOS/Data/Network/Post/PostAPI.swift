//
//  PostAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 6/10/26.
//

import Alamofire

enum PostAPI: BaseTargetType {
    case fetchHome
    case fetchFeeds(artistId: Int?, sort: FeedsSortOption, page: Int)
    case fetchPotList(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int)
    case fetchPotDetail(postId: Int)
    case fetchPotOptions(postId: Int)

    var path: String {
        switch self {
        case .fetchPotDetail(let postId):
            return "/api/v1/posts/\(postId)"
        case .fetchHome:
            return "api/v1/home"
        case .fetchFeeds:
            return "api/v1/feeds"
        case .fetchPotList:
            return "api/v1/posts/pots"
        case .fetchPotOptions(postId: let postId):
            return "/api/v1/posts/\(postId)/options"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPotDetail, .fetchHome, .fetchFeeds, .fetchPotList, .fetchPotOptions:
            return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchHome, .fetchPotDetail, .fetchPotOptions:
            return nil

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

    var bodyParameters: Parameters? {
        return nil
    }
}
