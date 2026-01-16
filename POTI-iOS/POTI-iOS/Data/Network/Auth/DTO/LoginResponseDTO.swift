//
//  LoginResponseDTO.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
    let userId: Int
}

extension LoginResponseDTO {
    func toLoginResponseEntity() -> LoginResponseEntity {
        LoginResponseEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            isNewUser: isNewUser,
            userId: userId
        )
    }
}
