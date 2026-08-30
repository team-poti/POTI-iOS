//
//  NotificationSettingsDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

struct NotificationSettingsDTO: Decodable {
    let tradeNotificationEnabled: Bool
    let eventNotificationEnabled: Bool

    func toEntity() -> NotificationSettingsEntity {
        return NotificationSettingsEntity(isTradeNotificationEnabled: tradeNotificationEnabled,
                                          isEventNotificationEnabled: eventNotificationEnabled)
    }
}
