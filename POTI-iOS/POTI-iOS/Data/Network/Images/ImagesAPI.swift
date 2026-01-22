//
//  ImagesAPI.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import Alamofire

enum ImagesAPI: BaseTargetType {
    case getPresignedUrls(type: String, extensions: [String])
    
    var path: String {
        switch self {
        case .getPresignedUrls:
            return "/api/v1/images/presigned-url"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPresignedUrls:
            return .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .getPresignedUrls(let type, let extensions):
            return [
                "type": type,
                "extensions": extensions.joined(separator: ",")
            ]
        }
    }
}
