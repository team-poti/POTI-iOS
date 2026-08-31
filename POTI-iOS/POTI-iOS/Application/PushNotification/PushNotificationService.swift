//
//  PushNotificationService.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import UIKit
import UserNotifications

import FirebaseMessaging

final class PushNotificationService: NSObject {

    // MARK: - Properties

    var onFCMTokenUpdated: ((String) -> Void)?
    var onNotificationOpened: ((PushNotificationPayload) -> Void)?

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
    }

    func handleAPNsRegistrationFailure(_ error: Error) {
        PotiLogger.error(error)
    }

}

// MARK: - MessagingDelegate

extension PushNotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        onFCMTokenUpdated?(fcmToken)
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
