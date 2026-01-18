//
//  DefaultAuthRepository.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

final class DefaultAuthRepository: AuthInterface {
    
    private let authService: AuthService
    private let networkService: NetworkService
    
    init(
        authService: AuthService,
        networkService: NetworkService
    ) {
        self.authService = authService
        self.networkService = networkService
    }
    
    func kakaoLogin() async throws -> LoginResponseEntity {
        let kakaoToken = try await authService.kakaoRequest()
        let result = try await networkService.request(
            target: AuthAPI.login(socialType: "KAKAO", token: kakaoToken), type: LoginResponseDTO.self
            )
        return result.toLoginResponseEntity()
    }
    
    func devLogin() async throws -> LoginResponseEntity {
        let result = try await networkService.request(target: AuthAPI.devLogin, type: DevLoginResponseDTO.self)
        return result.toLoginResponseEntity()
    }
}
