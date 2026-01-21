//
//  LoginResponseEntity.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Foundation

struct LoginResponseEntity: Codable {
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
    let userId: Int
}
