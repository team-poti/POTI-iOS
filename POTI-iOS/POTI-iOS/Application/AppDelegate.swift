//
//  AppDelegate.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/7/26.
//

import UIKit

import FirebaseCore
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let pushNotificationService = PushNotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configurePushNotifications(application)

        do {
            let appKey = try AppConfig.kakaoAppKey()
            KakaoSDK.initSDK(appKey: appKey)
        } catch {
            PotiLogger.error(error)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - Push Notification

private extension AppDelegate {
    func configurePushNotifications(_ application: UIApplication) {
        let fcmTokenSyncService = AppDIContainer.shared.makeFCMTokenSyncService()

        pushNotificationService.onFCMTokenUpdated = { token in
            Task {
                await fcmTokenSyncService.synchronize(token: token)
            }
        }

        pushNotificationService.onDeepLinkReceived = { [weak application] url in
            let sceneDelegate = application?.connectedScenes
                .compactMap { $0.delegate as? SceneDelegate }
                .first
            sceneDelegate?.handleDeepLink(url)
        }

        pushNotificationService.configure(application)
    }
}

// MARK: - Remote Notification

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushNotificationService.registerAPNsToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        pushNotificationService.handleAPNsRegistrationFailure(error)
    }

    // TODO: 서버가 APNs alert 페이로드 반영해주면 data-only 수신 처리와 함께 제거
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushNotificationService.handleRemoteNotification(userInfo, completion: completionHandler)
    }
}
