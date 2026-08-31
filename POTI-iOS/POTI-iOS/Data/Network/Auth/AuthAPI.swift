//
//  AuthAPI.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Alamofire

enum AuthAPI: BaseTargetType {
    case login(socialType: String, token: String, name: String?)
    case reissue(refreshToken: String)
    case devLogin
    case logout(fcmToken: String?)
    case withdrawalReasons
    case withdrawalUser(reason: String)

    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .reissue:
            return "/api/v1/auth/reissue"
        case .devLogin:
            return "/dev/login"
        case .logout:
            return "/api/v1/auth/logout"
        case .withdrawalReasons:
            return "/api/v1/auth/withdrawal/reasons"
        case .withdrawalUser:
            return "/api/v1/auth/withdrawal"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .reissue, .logout:
            return .post
        case .devLogin, .withdrawalReasons:
            return .get
        case .withdrawalUser:
            return .delete
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .login(let socialType, let token, let name):
            var parameters: Parameters = [
                "socialType": socialType,
                "token": token
            ]
            if let name, !name.isEmpty {
                parameters["name"] = name
            }
            return parameters
        case .reissue(let refreshToken):
            return [
                "refreshToken": refreshToken
            ]
        case .logout(let fcmToken):
            guard let fcmToken else { return [:] }
            return ["fcmToken": fcmToken]
        case .withdrawalUser(let reason):
            return ["reason": reason]
        case .devLogin, .withdrawalReasons:
            return nil
        }
    }
}
