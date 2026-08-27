//
//  GetNotificationSettingsUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol GetNotificationSettingsUseCase {
    func execute() async throws -> NotificationSettingsEntity
}

final class DefaultGetNotificationSettingsUseCase: GetNotificationSettingsUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute() async throws -> NotificationSettingsEntity { try await repository.fetchNotificationSettings() }
}
