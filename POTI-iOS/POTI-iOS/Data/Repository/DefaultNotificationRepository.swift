//
//  DefaultNotificationRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

final class DefaultNotificationRepository: NotificationInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchNotifications(page: Int) async throws -> NotificationPageEntity {
        let response: NotificationResponseDTO = try await networkService.request(target: NotificationAPI.fetchNotifications(page: page),
                                                                                  type: NotificationResponseDTO.self)
        return response.toEntity(currentPage: page)
    }

    func readNotification(notificationId: Int) async throws {
        let _: EmptyResponse = try await networkService.request(target: NotificationAPI.readNotification(notificationId: notificationId),
                                                                type: EmptyResponse.self)
    }

    func readAllNotifications() async throws {
        let _: EmptyResponse = try await networkService.request(target: NotificationAPI.readAllNotifications, type: EmptyResponse.self)
    }

    func fetchSettings() async throws -> NotificationSettingsEntity {
        let response: NotificationSettingsDTO = try await networkService.request(target: NotificationAPI.fetchSettings,
                                                                                  type: NotificationSettingsDTO.self)
        return response.toEntity()
    }

    func updateSettings(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool) async throws -> NotificationSettingsEntity {
        let response: NotificationSettingsDTO = try await networkService.request(
            target: NotificationAPI.updateSettings(tradeNotificationEnabled: tradeNotificationEnabled,
                                                   eventNotificationEnabled: eventNotificationEnabled), type: NotificationSettingsDTO.self)
        return response.toEntity()
    }
}
