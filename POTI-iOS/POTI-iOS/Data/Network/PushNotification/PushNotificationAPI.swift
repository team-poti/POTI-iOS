//
//  PushNotificationAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import Alamofire

enum PushNotificationAPI: BaseTargetType {
    case registerToken(token: String)
    case deleteToken(token: String)

    var path: String {
        return "/api/v1/fcm-tokens"
    }

    var method: HTTPMethod {
        switch self {
        case .registerToken:
            return .post
        case .deleteToken:
            return .delete
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .registerToken:
            return nil
        case .deleteToken(let token):
            return ["token": token]
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .registerToken(let token):
            return ["token": token, "deviceType": "IOS"]
        case .deleteToken:
            return nil
        }
    }
}
