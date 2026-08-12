//
//  ArtistsDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/18/26.
//

struct ArtistsDTO: Decodable {
    let members: [ArtistDTO]

    func toEntities() -> [ArtistMemberEntity] {
        members.map { $0.toEntity() }
    }
}

struct ArtistDTO: Decodable {
    let memberId: Int
    let name: String
    
    func toEntity() -> ArtistMemberEntity {
        ArtistMemberEntity(memberId: memberId, name: name)
    }
}
