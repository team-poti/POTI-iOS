//
//  SceneDelegate.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/7/26.
//

import UIKit

import KakaoSDKAuth

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var deepLinkHandler: DeepLinkHandler?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let factory = DefaultViewControllerFactory()
        configureDeepLinkHandler(with: factory)

        let splashViewController = factory.makeLaunchScreenViewController()
        window.rootViewController = splashViewController
        self.window = window
        window.makeKeyAndVisible()

        if let notificationResponse = connectionOptions.notificationResponse {
            let payload = PushNotificationPayload(userInfo: notificationResponse.notification.request.content.userInfo)
            handlePushNotification(payload)
        }

        guard let url = connectionOptions.userActivities
            .first(where: { $0.activityType == NSUserActivityTypeBrowsingWeb })?
            .webpageURL else { return }
        handleDeepLink(url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        handleDeepLink(url)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - Root Navigation

extension SceneDelegate {
    func handlePushNotification(_ payload: PushNotificationPayload) {
        if let notificationId = payload.notificationId {
            let readNotificationUseCase = AppDIContainer.shared.makeReadNotificationUseCase()
            Task {
                do {
                    try await readNotificationUseCase.execute(notificationId: notificationId)
                } catch {
                    PotiLogger.error(error)
                }
            }
        }

        guard let deepLink = payload.deepLink else { return }
        handleDeepLink(deepLink)
    }

    func handleDeepLink(_ url: URL) {
        deepLinkHandler?.handle(url, from: window?.rootViewController)
    }

    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window else {
            PotiLogger.error(NSError(domain: "윈도우를 찾을 수 없습니다", code: -1))
            return
        }

        deepLinkHandler?.executePendingRouteIfNeeded(from: viewController)

        viewController.view.frame = window.bounds
        viewController.view.layoutIfNeeded()

        let completion: (Bool) -> Void = { [weak self] _ in
            self?.deepLinkHandler?.executePendingRouteIfNeeded(from: viewController)
        }

        if animated {
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                window.rootViewController = viewController
            }, completion: completion)
        } else {
            window.rootViewController = viewController
            completion(true)
        }

        window.makeKeyAndVisible()
    }
}

// MARK: - Deep Link

private extension SceneDelegate {
    func configureDeepLinkHandler(with factory: ViewControllerFactory) {
        do {
            let parser = DeepLinkParser(allowedHost: try AppConfig.deepLinkHost())
            let router = DeepLinkRouter(factory: factory)
            deepLinkHandler = DeepLinkHandler(parser: parser, router: router)
        } catch {
            PotiLogger.error(error)
        }
    }
}
