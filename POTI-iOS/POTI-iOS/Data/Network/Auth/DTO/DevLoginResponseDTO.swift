//
//  DevLoginResponseDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/18/26.
//

struct DevLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension DevLoginResponseDTO {
    func toLoginResponseEntity() -> LoginResponseEntity {
        LoginResponseEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            isNewUser: false,
            userId: 1
        )
    }
}
