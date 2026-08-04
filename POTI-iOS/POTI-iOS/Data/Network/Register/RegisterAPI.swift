//
//  RegisterAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import Alamofire

enum RegisterAPI: BaseTargetType {
    case registerPosts(CreatePostRequestDTO)
    case fetchProductTitles(artistId: Int, keyword: String)
    case searchArtists(keyword: String)

    var path: String {
        switch self {
        case .registerPosts:
            return "/api/v1/posts"
        case .fetchProductTitles:
            return "/api/v1/posts/titles"
        case .searchArtists:
            return "/api/v1/posts/artists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registerPosts:
            return .post
        case .fetchProductTitles, .searchArtists:
            return .get
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .fetchProductTitles(let artistId, let keyword):
            return [
                "artistId": "\(artistId)",
                "keyword": keyword
            ]

        case .searchArtists(let keyword):
            return ["keyword": keyword]

        case .registerPosts:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .registerPosts(let dto):
            return dto
        default:
            return nil
        }
    }
}
