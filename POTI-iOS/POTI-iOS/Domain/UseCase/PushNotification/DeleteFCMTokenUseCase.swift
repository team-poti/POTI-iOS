//
//  DeleteFCMTokenUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

protocol DeleteFCMTokenUseCase {
    func execute(token: String) async throws
}

final class DefaultDeleteFCMTokenUseCase: DeleteFCMTokenUseCase {
    private let repository: PushNotificationRepository

    init(repository: PushNotificationRepository) {
        self.repository = repository
    }

    func execute(token: String) async throws {
        try await repository.deleteFCMToken(token)
    }
}
