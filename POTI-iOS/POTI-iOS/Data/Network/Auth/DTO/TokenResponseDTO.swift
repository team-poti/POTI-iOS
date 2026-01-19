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
