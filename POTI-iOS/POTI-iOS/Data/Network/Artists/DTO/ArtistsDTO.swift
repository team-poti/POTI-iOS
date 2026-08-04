//
//  ArtistsDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/18/26.
//

struct ArtistsDTO: Decodable {
    let members: [ArtistDTO]
}

struct ArtistDTO: Decodable {
    let memberId: Int
    let name: String
    
    func toEntity() -> ArtistMemberEntity {
        ArtistMemberEntity(memberId: memberId, name: name)
    }
}
