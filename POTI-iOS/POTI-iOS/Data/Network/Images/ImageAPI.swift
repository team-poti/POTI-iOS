//
//  ImageAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Alamofire

enum ImageAPI: BaseTargetType {
    case fetchPresignedURLs(type: String, fileExtensions: [String])

    var path: String {
        "/api/v1/images/presigned-url"
    }

    var method: HTTPMethod {
        .get
    }

    var queryParameters: [String: String]? {
        switch self {
        case let .fetchPresignedURLs(type, fileExtensions):
            return ["type": type, "extensions": fileExtensions.joined(separator: ",")]
        }
    }
}
