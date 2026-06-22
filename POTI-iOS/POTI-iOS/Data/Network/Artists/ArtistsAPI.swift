//
//  MemberAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import Alamofire

enum ArtistsAPI {
    case fetchArtistMembers(artistId: Int)
    case fetchOnboardingArtistsList
}

extension ArtistsAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchArtistMembers(let artistId):
            return "/api/v1/artists/\(artistId)/members"
        case .fetchOnboardingArtistsList:
            return "/api/v1/artists"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArtistMembers, .fetchOnboardingArtistsList:
            return .get
        }
    }
}
