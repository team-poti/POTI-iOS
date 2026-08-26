//
//  FCMTokenSyncService.swift
//  POTI-iOS
//
//  Created by soomin on 8/26/26.
//

protocol FCMTokenSyncService: AnyObject {
    func synchronize(token: String?) async
    func deleteToken() async
}

final class DefaultFCMTokenSyncService: FCMTokenSyncService {

    // MARK: - Properties

    private let registerFCMTokenUseCase: RegisterFCMTokenUseCase
    private let deleteFCMTokenUseCase: DeleteFCMTokenUseCase
    private let tokenStore: FCMTokenStore

    // MARK: - Initializer

    init(registerFCMTokenUseCase: RegisterFCMTokenUseCase, deleteFCMTokenUseCase: DeleteFCMTokenUseCase, tokenStore: FCMTokenStore) {
        self.registerFCMTokenUseCase = registerFCMTokenUseCase
        self.deleteFCMTokenUseCase = deleteFCMTokenUseCase
        self.tokenStore = tokenStore
    }

    // MARK: - Public Methods

    func synchronize(token: String? = nil) async {
        if let token {
            tokenStore.save(token)
        }

        guard KeychainManager.getAccessToken() != nil,
              let storedToken = tokenStore.token else { return }

        do {
            try await registerFCMTokenUseCase.execute(token: storedToken)
        } catch {
            PotiLogger.error(error)
        }
    }

    // TODO: 로그아웃/회원탈퇴 기능 구현 시 인증 정보 삭제 전에 호출하기
    func deleteToken() async {
        guard let token = tokenStore.token else { return }

        do {
            try await deleteFCMTokenUseCase.execute(token: token)
            tokenStore.clear()
        } catch {
            PotiLogger.error(error)
        }
    }
}
