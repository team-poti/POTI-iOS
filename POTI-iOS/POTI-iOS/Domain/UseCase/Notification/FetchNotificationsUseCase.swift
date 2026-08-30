//
//  FetchNotificationsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol FetchNotificationsUseCase {
    func execute(page: Int) async throws -> NotificationPageEntity
}

final class DefaultFetchNotificationsUseCase: FetchNotificationsUseCase {
    private let repository: NotificationInterface

    init(repository: NotificationInterface) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> NotificationPageEntity {
        return try await repository.fetchNotifications(page: page)
    }
}
