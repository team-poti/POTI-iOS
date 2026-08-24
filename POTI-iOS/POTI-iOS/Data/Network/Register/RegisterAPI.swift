//
//  RegisterAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import Alamofire

enum RegisterAPI: BaseTargetType {
    case registerPost(RegisterPostRequestDTO)
    case fetchProductTitles(artistId: Int, keyword: String)
    case searchArtists(keyword: String)

    var path: String {
        switch self {
        case .registerPost:
            return "/api/v1/posts"
        case .fetchProductTitles:
            return "/api/v1/posts/titles"
        case .searchArtists:
            return "/api/v1/posts/artists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registerPost:
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

        case .registerPost:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .registerPost(let dto):
            return [
                "artistId": dto.artistId,
                "title": dto.title,
                "content": dto.content,
                "deadline": dto.deadline,
                "bankName": dto.bankName,
                "accountNumber": dto.accountNumber,
                "imageUrls": dto.imageUrls,
                "options": dto.options.map { [
                    "memberId": $0.memberId,
                    "price": $0.price
                ]},
                "shippings": dto.shippings.map { [
                    "deliveryMethodId": $0.deliveryMethodId,
                    "price": $0.price
                ]}
            ]
        default:
            return nil
        }
    }
}
