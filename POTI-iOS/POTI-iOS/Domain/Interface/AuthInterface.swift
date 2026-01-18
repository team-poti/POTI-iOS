//
//  AuthInterface.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

protocol AuthInterface {
    func kakaoLogin() async throws -> LoginResponseEntity
    func devLogin() async throws -> LoginResponseEntity
}
