//
//  AuthAPI.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Alamofire

enum AuthAPI: BaseTargetType {
    case login(socialType: String, token: String)
    case reissue(refreshToken: String)
    case devLogin

    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .reissue:
            return "/api/v1/auth/reissue"
        case .devLogin:
            return "/dev/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .reissue:
            return .post
        case .devLogin:
            return .get
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .login(let socialType, let provider):
            return [
                "socialType": socialType,
                "token": provider
            ]
        case .reissue(let refreshToken):
            return [
                "refreshToken": refreshToken
            ]
        case .devLogin:
            return nil
        }
    }
}
