//
//  RegisterArtistsResponseDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

struct RegisterArtistsResponseDTO: Decodable {
    let code: Int
    let msg: String
    let data: DataDTO

    struct DataDTO: Decodable {
        let artists: [ArtistDTO]
    }

    struct ArtistDTO: Decodable {
        let artistId: Int
        let name: String
    }

    private enum CodingKeys: String, CodingKey {
        case code
        case msg
        case message
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = try container.decode(Int.self, forKey: .code)

        // msg / message 둘 다 대응
        if let msg = try? container.decode(String.self, forKey: .msg) {
            self.msg = msg
        } else if let message = try? container.decode(String.self, forKey: .message) {
            self.msg = message
        } else {
            self.msg = ""
        }

        self.data = try container.decode(DataDTO.self, forKey: .data)
    }
}

extension RegisterArtistsResponseDTO {
    func toEntities() -> [RegisterArtistEntity] {
        data.artists.map { $0.toEntity() }
    }
}

extension RegisterArtistsResponseDTO.ArtistDTO {
    func toEntity() -> RegisterArtistEntity {
        RegisterArtistEntity(artistId: artistId, name: name)
    }
}
