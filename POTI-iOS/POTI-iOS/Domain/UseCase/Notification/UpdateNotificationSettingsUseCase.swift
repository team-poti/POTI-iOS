//
//  UpdateNotificationSettingsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol UpdateNotificationSettingsUseCase {
    func execute(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool) async throws -> NotificationSettingsEntity
}

final class DefaultUpdateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase {
    private let repository: NotificationInterface

    init(repository: NotificationInterface) {
        self.repository = repository
    }

    func execute(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool) async throws -> NotificationSettingsEntity {
        return try await repository.updateSettings(tradeNotificationEnabled: tradeNotificationEnabled,
                                                   eventNotificationEnabled: eventNotificationEnabled)
    }
}
