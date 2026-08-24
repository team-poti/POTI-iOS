//
//  AuthService.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import AuthenticationServices
import Foundation
import UIKit

import KakaoSDKUser

struct AppleAuthorizationCredential {
    let identityToken: String
    let name: String?
}

@MainActor
protocol AuthService {
    func kakaoRequest() async throws -> String
    func appleRequest() async throws -> AppleAuthorizationCredential
}

@MainActor
final class DefaultAuthService: NSObject, AuthService {
    private var appleContinuation: CheckedContinuation<AppleAuthorizationCredential, Error>?

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

    func appleRequest() async throws -> AppleAuthorizationCredential {
        guard appleContinuation == nil else {
            throw PotiError.appleAuthorizationError
        }

        return try await withCheckedThrowingContinuation { continuation in
            appleContinuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension DefaultAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let continuation = appleContinuation else { return }
        appleContinuation = nil

        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.identityToken,
            let identityToken = String(data: tokenData, encoding: .utf8),
            !identityToken.isEmpty
        else {
            continuation.resume(throwing: PotiError.appleAuthorizationError)
            return
        }

        let name = credential.fullName.flatMap { components -> String? in
            let formatter = PersonNameComponentsFormatter()
            let formattedName = formatter
                .string(from: components)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return formattedName.isEmpty ? nil : formattedName
        }

        continuation.resume(
            returning: AppleAuthorizationCredential(
                identityToken: identityToken,
                name: name
            )
        )
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        guard let continuation = appleContinuation else { return }
        appleContinuation = nil

        if let authorizationError = error as? ASAuthorizationError,
           authorizationError.code == .canceled {
            continuation.resume(throwing: CancellationError())
        } else {
            PotiLogger.error(error)
            continuation.resume(throwing: PotiError.appleAuthorizationError)
        }
    }
}

extension DefaultAuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        let foregroundScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }

        return foregroundScene?.windows.first(where: \.isKeyWindow)
        ?? foregroundScene?.windows.first
        ?? ASPresentationAnchor()
    }
}
