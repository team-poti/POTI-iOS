//
//  MemberResponseDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

struct ArtistsResponseDTO: Decodable {
    let data: ArtistsDataDTO
}

struct ArtistsDataDTO: Decodable {
    let members: [ArtistDTO]
}

struct ArtistDTO: Decodable {
    let memberId: Int
    let name: String
    
    func toEntity() -> ArtistsEntity {
        return ArtistsEntity(artistId: memberId, artistName: name)
    }
}
