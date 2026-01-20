//
//  TokenResponseDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension TokenResponseDTO {
    func toTokenEntity() -> TokenEntity {
        TokenEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
