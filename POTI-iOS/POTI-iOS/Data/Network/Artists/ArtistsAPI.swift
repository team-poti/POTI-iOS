//
//  MemberAPI.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import Alamofire

enum ArtistsAPI {
    case fetchArtistsList(artistId: Int)
}

extension ArtistsAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchArtistsList(let artistId):
            return "/api/v1/artists/\(artistId)/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArtistsList:
            return .get
        }
    }
}
