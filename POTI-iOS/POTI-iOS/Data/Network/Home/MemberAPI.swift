//
//  MemberAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import Alamofire

enum MemberAPI {
    case fetchMemberList(artistId: Int)
}

extension MemberAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchMemberList(let artistId):
            return "/api/v1/artists/\(artistId)/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMemberList:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchMemberList:
            return .basic
        }
    }
}
