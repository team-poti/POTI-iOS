//
//  AuthService.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import KakaoSDKUser

protocol AuthService {
    func kakaoRequest() async throws -> String
}

@MainActor
final class DefaultAuthService: AuthService {
    func kakaoRequest() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    if let error {
                        PotiLogger.error(error)
                        continuation.resume(throwing: PotiError.kakaoOuathError)
                    } else if let accessToken = token?.accessToken {
                        PotiLogger.debug("카카오 로그인 토큰 받기 성공")
                        continuation.resume(returning: accessToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { token, error in
                    if let error {
                        PotiLogger.error(error)
                        continuation.resume(throwing: PotiError.kakaoOuathError)
                    } else if let accessToken = token?.accessToken {
                        PotiLogger.debug("카카오 로그인 토큰 받기 성공")
                        continuation.resume(returning: accessToken)
                    }
                }
            }
        }
    }
}
