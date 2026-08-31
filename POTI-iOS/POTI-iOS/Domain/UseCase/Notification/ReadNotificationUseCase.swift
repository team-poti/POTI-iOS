//
//  ReadNotificationUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol ReadNotificationUseCase {
    func execute(notificationId: Int) async throws
}

final class DefaultReadNotificationUseCase: ReadNotificationUseCase {
    private let repository: NotificationInterface

    init(repository: NotificationInterface) {
        self.repository = repository
    }

    func execute(notificationId: Int) async throws {
        try await repository.readNotification(notificationId: notificationId)
    }
}
