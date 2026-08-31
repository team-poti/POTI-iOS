//
//  PushNotificationService.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import UIKit
import UserNotifications

import FirebaseInstallations
import FirebaseMessaging

final class PushNotificationService: NSObject {

    // MARK: - Properties

    var onFCMTokenUpdated: ((String) -> Void)?
    var onNotificationOpened: ((PushNotificationPayload) -> Void)?
    private var currentRegistrationId: String?

    // MARK: - Public Methods

    func configure(_ application: UIApplication) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        Messaging.messaging().delegate = self

        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized ||
                    settings.authorizationStatus == .provisional ||
                    settings.authorizationStatus == .ephemeral else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    func registerAPNsToken(_ token: Data) {
        Messaging.messaging().apnsToken = token

        Messaging.messaging().register { error in
            if let error {
                PotiLogger.error(error)
                return
            }

            Installations.installations().installationID { [weak self] installationId, error in
                if let error {
                    PotiLogger.error(error)
                    return
                }
                guard let installationId else { return }
                self?.handleRegistrationId(installationId)
            }
        }
    }

    func handleAPNsRegistrationFailure(_ error: Error) {
        PotiLogger.error(error)
    }

    private func handleRegistrationId(_ registrationId: String) {
        guard currentRegistrationId != registrationId else { return }
        currentRegistrationId = registrationId
        onFCMTokenUpdated?(registrationId)
    }
}

// MARK: - MessagingDelegate

extension PushNotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistration installationId: String?) {
        guard let installationId else { return }
        handleRegistrationId(installationId)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }

        let payload = PushNotificationPayload(userInfo: response.notification.request.content.userInfo)
        onNotificationOpened?(payload)
    }
}
