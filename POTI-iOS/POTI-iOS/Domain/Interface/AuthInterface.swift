//
//  AuthInterface.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

protocol AuthInterface {
    func login(socialType: String, token: String) async throws -> LoginResponseEntity
}
