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
    var onDeepLinkReceived: ((URL) -> Void)?

    // MARK: - Public Methods

    func configure(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, error in
            if let error {
                PotiLogger.error(error)
                return
            }

            guard isGranted else { return }
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

    // TODO: 서버에서 APNs alert 페이로드로 반영해주면 로컬 알림 생성 로직과 함께 제거
    func handleRemoteNotification(_ userInfo: [AnyHashable: Any], completion: @escaping (UIBackgroundFetchResult) -> Void) {
        let payload = PushNotificationPayload(userInfo: userInfo)
        
        guard let title = payload.title,
              let body = payload.body else {
            completion(.noData)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                PotiLogger.error(error)
                completion(.failed)
                return
            }

            completion(.newData)
        }
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
        guard let deepLink = payload.deepLink else { return }
        onDeepLinkReceived?(deepLink)
    }
}
