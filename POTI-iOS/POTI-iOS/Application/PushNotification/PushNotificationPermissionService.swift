//
//  PushNotificationPermissionService.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit
import UserNotifications

enum PushNotificationPermissionResult {
    case granted
    case denied
    case openedSettings
}

protocol PushNotificationPermissionService {
    func authorizationStatus() async -> UNAuthorizationStatus
    func requestPermissionOrOpenSettings() async -> PushNotificationPermissionResult
    func isPermissionAllowed() async -> Bool
}

final class DefaultPushNotificationPermissionService: PushNotificationPermissionService {
    
    // MARK: - Property

    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Public Methods
    
    func authorizationStatus() async -> UNAuthorizationStatus {
        await notificationCenter.notificationSettings().authorizationStatus
    }

    @MainActor
    func requestPermissionOrOpenSettings() async -> PushNotificationPermissionResult {
        switch await authorizationStatus() {
        case .notDetermined:
            do {
                let isGranted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                if isGranted {
                    UIApplication.shared.registerForRemoteNotifications()
                    return .granted
                }
                return .denied
            } catch {
                PotiLogger.error(error)
                return .denied
            }

        case .denied:
            guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return .denied }
            await UIApplication.shared.open(settingsURL)
            return .openedSettings

        case .authorized, .provisional, .ephemeral:
            UIApplication.shared.registerForRemoteNotifications()
            return .granted

        @unknown default:
            return .denied
        }
    }

    func isPermissionAllowed() async -> Bool {
        switch await authorizationStatus() {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }
}
