//
//  DefaultPushNotificationRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

final class DefaultPushNotificationRepository: PushNotificationRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func registerFCMToken(_ token: String) async throws {
        try await networkService.request(target: PushNotificationAPI.registerToken(token: token), type: EmptyResponse.self)
    }

    func deleteFCMToken(_ token: String) async throws {
        try await networkService.request(target: PushNotificationAPI.deleteToken(token: token), type: EmptyResponse.self)
    }
}
