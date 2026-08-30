//
//  DefaultFCMTokenSyncService.swift
//  POTI-iOS
//
//  Created by soomin on 8/30/26.
//

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

    func deleteToken() async throws {
        guard let token = tokenStore.token else { return }
        try await deleteFCMTokenUseCase.execute(token: token)
    }
}
