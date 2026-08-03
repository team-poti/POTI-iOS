//
//  ArtistSearchResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

struct ArtistSearchResponseDTO: Decodable {
    let artists: [ArtistSearchResultDTO]

    private enum CodingKeys: String, CodingKey {
        case artists
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artists = try container.decodeIfPresent([ArtistSearchResultDTO].self, forKey: .artists) ?? []
    }
    
    func toEntities() -> [ArtistSearchResultEntity] {
        artists.map { $0.toEntity() }
    }
}

struct ArtistSearchResultDTO: Decodable {
    let artistId: Int
    let name: String
    
    func toEntity() -> ArtistSearchResultEntity {
        ArtistSearchResultEntity(artistId: artistId, name: name)
    }
}
