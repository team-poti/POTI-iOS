//
//  UpdateNotificationSettingsUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol UpdateNotificationSettingsUseCase {
    func execute(tradeEnabled: Bool, eventEnabled: Bool) async throws -> NotificationSettingsEntity
}

final class DefaultUpdateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute(tradeEnabled: Bool, eventEnabled: Bool) async throws -> NotificationSettingsEntity {
        try await repository.updateNotificationSettings(tradeEnabled: tradeEnabled, eventEnabled: eventEnabled)
    }
}
