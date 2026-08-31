//
//  PushNotificationRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

protocol PushNotificationRepository {
    func registerFCMToken(_ token: String) async throws
    func deleteFCMToken(_ token: String) async throws
}
