//
//  RegisterFCMTokenUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

protocol RegisterFCMTokenUseCase {
    func execute(token: String) async throws
}

final class DefaultRegisterFCMTokenUseCase: RegisterFCMTokenUseCase {
    private let repository: PushNotificationRepository

    init(repository: PushNotificationRepository) {
        self.repository = repository
    }

    func execute(token: String) async throws {
        try await repository.registerFCMToken(token)
    }
}
