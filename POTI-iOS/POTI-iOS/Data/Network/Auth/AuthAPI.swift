//
//  AuthAPI.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Alamofire

enum AuthAPI: BaseTargetType {
    case login(socialType: String, token: String)

    var path: String {
        "/auth/login"
    }

    var method: HTTPMethod {
        .post
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
        }
    }
}
