//
//  RegisterArtistsResponseDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

struct RegisterArtistsResponseDTO: Decodable {
    let artists: [RegisterArtistDTO]
}

struct RegisterArtistDTO: Decodable {
    let artistId: Int?
    let name: String?
}

extension RegisterArtistsResponseDTO {
    func toEntities() -> [RegisterArtistEntity] {
        artists.map { $0.toEntity() }
    }
}

extension RegisterArtistDTO {
    func toEntity() -> RegisterArtistEntity {
        return RegisterArtistEntity(
            artistId: artistId,
            name: name
        )
    }
}
