//
//  ReadAllNotificationsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol ReadAllNotificationsUseCase {
    func execute() async throws
}

final class DefaultReadAllNotificationsUseCase: ReadAllNotificationsUseCase {
    private let repository: NotificationInterface

    init(repository: NotificationInterface) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.readAllNotifications()
    }
}
