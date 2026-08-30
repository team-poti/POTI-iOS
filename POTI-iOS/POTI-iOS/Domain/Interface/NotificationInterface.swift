//
//  NotificationInterface.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

protocol NotificationInterface {
    func fetchNotifications(page: Int) async throws -> NotificationPageEntity
    func readNotification(notificationId: Int) async throws
    func readAllNotifications() async throws
    func fetchSettings() async throws -> NotificationSettingsEntity
    func updateSettings(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool) async throws -> NotificationSettingsEntity
}
