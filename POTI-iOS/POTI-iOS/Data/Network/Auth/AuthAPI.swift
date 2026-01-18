//
//  AuthAPI.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Alamofire

enum AuthAPI: BaseTargetType {
    case login(socialType: String, token: String)
    case devLogin

    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .devLogin:
            return "dev/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .devLogin:
            return .get
        }
    }

    var headers: HeaderType {
        .basic
    }

    var bodyParameters: Parameters? {
        switch self {
        case .login(let socialType, let provider):
            return [
                "socialType": socialType,
                "token": provider
            ]
        case .devLogin:
            return nil
        }
    }
}
