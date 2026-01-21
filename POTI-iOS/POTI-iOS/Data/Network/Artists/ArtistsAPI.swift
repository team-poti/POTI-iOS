//
//  MemberAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import Alamofire

enum ArtistsAPI {
    case fetchArtistsList(artistId: Int)
    case fetchOnboardingArtistsList
}

extension ArtistsAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchArtistsList(let artistId):
            return "/api/v1/artists/\(artistId)/members"
        case .fetchOnboardingArtistsList:
            return "/api/v1/artists"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArtistsList, .fetchOnboardingArtistsList:
            return .get
        }
    }
}
