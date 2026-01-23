//
//  DefaultAuthRepository.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Foundation

final class DefaultAuthRepository: AuthInterface {
    
    private let authService: AuthService
    private let networkService: NetworkService
    private let tokenRefreshNetworkService: NetworkService
    
    init(
        authService: AuthService,
        networkService: NetworkService,
        tokenRefreshNetworkService: NetworkService
    ) {
        self.authService = authService
        self.networkService = networkService
        self.tokenRefreshNetworkService = tokenRefreshNetworkService
    }
    
    func kakaoLogin() async throws -> LoginResponseEntity {
        let kakaoToken = try await authService.kakaoRequest()
        let result = try await tokenRefreshNetworkService.request(
            target: AuthAPI.login(socialType: "KAKAO", token: kakaoToken), type: LoginResponseDTO.self
            )
        
        KeychainManager.saveTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
        
        return result.toLoginResponseEntity()
    }
    
    func devLogin() async throws -> LoginResponseEntity {
        let result = try await tokenRefreshNetworkService.request(target: AuthAPI.devLogin, type: DevLoginResponseDTO.self)
        KeychainManager.saveTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
        return result.toLoginResponseEntity()
    }
    
    func refreshToken() async throws {
        guard let currentRefreshToken = KeychainManager.getRefreshToken() else {
            throw PotiError.unauthorized
        }
        
        let result = try await tokenRefreshNetworkService.request(
            target: AuthAPI.reissue(refreshToken: currentRefreshToken),
            type: TokenResponseDTO.self
        )
        
        KeychainManager.saveTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
        let verifyAccess = KeychainManager.getAccessToken()
        let verifyRefresh = KeychainManager.getRefreshToken()
            
        guard verifyAccess == result.accessToken,
              verifyRefresh == result.refreshToken else {
            PotiLogger.error(NSError(domain: "Keychain 저장 실패!", code: -1))
            throw PotiError.networkFail
        }
            
        PotiLogger.debug("Keychain 저장 및 검증 완료")
    }
    
    func withDraw() async throws {
        try await networkService.request(target: AuthAPI.withdrawalUser, type: EmptyResponse.self
        )
    }
}

struct EmptyResponse: Decodable {}
