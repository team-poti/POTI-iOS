//
//  AuthInterface.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

protocol AuthInterface {
    func kakaoLogin() async throws -> LoginResponseEntity
    func appleLogin() async throws -> LoginResponseEntity
    func devLogin() async throws -> LoginResponseEntity
    func refreshToken() async throws
    func withdraw(reason: String) async throws
    func logout() async throws
}
