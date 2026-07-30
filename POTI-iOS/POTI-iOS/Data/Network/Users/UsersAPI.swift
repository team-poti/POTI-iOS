//
//  UsersAPI.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import Alamofire

enum UsersAPI {
    case validateNickname(nickname: String)
    case submitOnboarding(nickname: String, favoriteArtistId: Int?)
    case getMyPageInformation
    case fetchYourPageInformation(userId: Int)
    case fetchMyPostsHistory(status: String)
    case fetchMyParticipationsHistory(status: String)
}

extension UsersAPI: BaseTargetType {

    var path: String {
        switch self {
        case .validateNickname:
            return "/api/v1/users/nickname/duplicate"
        case .submitOnboarding:
            return "/api/v1/users/onboarding"
        case .getMyPageInformation:
            return "/api/v1/users/mypage"
        case .fetchYourPageInformation(let userId):
            return "/api/v1/users/\(userId)/profile"
        case .fetchMyPostsHistory:
            return "/api/v1/posts/me"
        case .fetchMyParticipationsHistory:
            return "/api/v1/participations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .validateNickname:
            return .post
        case .submitOnboarding:
            return .patch
        case .getMyPageInformation, .fetchYourPageInformation, .fetchMyPostsHistory, .fetchMyParticipationsHistory:
            return .get

        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .validateNickname, .submitOnboarding, .getMyPageInformation, .fetchYourPageInformation:
            return nil
        case .fetchMyPostsHistory(let status), .fetchMyParticipationsHistory(let status):
            return ["status": status]
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .validateNickname(let nickname):
            return ["nickname": nickname]
        case .submitOnboarding(let nickname, let favoriteArtistId):
            return [
                "nickname": nickname,
                "favoriteArtistId": favoriteArtistId
            ]
        case .getMyPageInformation, .fetchYourPageInformation, .fetchMyPostsHistory, .fetchMyParticipationsHistory:
            return nil
        }
    }
}
