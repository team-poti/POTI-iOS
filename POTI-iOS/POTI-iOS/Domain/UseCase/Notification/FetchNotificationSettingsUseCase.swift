//
//  FetchNotificationSettingsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol FetchNotificationSettingsUseCase {
    func execute() async throws -> NotificationSettingsEntity
}

final class DefaultFetchNotificationSettingsUseCase: FetchNotificationSettingsUseCase {
    private let repository: NotificationInterface

    init(repository: NotificationInterface) {
        self.repository = repository
    }

    func execute() async throws -> NotificationSettingsEntity {
        return try await repository.fetchSettings()
    }
}
