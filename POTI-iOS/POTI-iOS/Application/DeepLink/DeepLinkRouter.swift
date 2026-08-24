//
//  DeepLinkRouter.swift
//  POTI-iOS
//
//  Created by soomin on 8/24/26.
//

import UIKit

@MainActor
final class DeepLinkRouter {
    private enum TabIndex {
        static let home = 0
        static let history = 1
    }

    // MARK: - Properties
    
    private let factory: ViewControllerFactory
    private var pendingRoute: DeepLinkRoute?
    private var lastRoute: DeepLinkRoute?
    private weak var lastRoutedViewController: UIViewController?
    
    // MARK: - Initializer

    init(factory: ViewControllerFactory) {
        self.factory = factory
    }
    
    // MARK: - Public Methods

    func route(to route: DeepLinkRoute, from rootViewController: UIViewController?) {
        guard let tabBarController = findTabBarController(from: rootViewController) else {
            pendingRoute = route
            return
        }

        pendingRoute = nil
        navigate(to: route, using: tabBarController)
    }

    func executePendingRouteIfNeeded(from rootViewController: UIViewController?) {
        guard let pendingRoute else { return }
        route(to: pendingRoute, from: rootViewController)
    }
    
    func navigate(to route: DeepLinkRoute, using tabBarController: PotiTabBar) {
        tabBarController.loadViewIfNeeded()

        let tabIndex = tabIndex(for: route)
        guard let viewControllers = tabBarController.viewControllers,
              viewControllers.indices.contains(tabIndex),
              let navigationController = viewControllers[tabIndex] as? UINavigationController else {
            pendingRoute = route
            return
        }

        if lastRoute == route,
           navigationController.topViewController === lastRoutedViewController {
            return
        }

        tabBarController.dismiss(animated: false)
        tabBarController.selectedIndex = tabIndex
        navigationController.popToRootViewController(animated: false)

        let destinationViewController = makeViewController(for: route)
        destinationViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(destinationViewController, animated: false)

        lastRoute = route
        lastRoutedViewController = destinationViewController
    }

    func tabIndex(for route: DeepLinkRoute) -> Int {
        switch route {
        case .potDetail:
            return TabIndex.home
        case .participantDetail, .recruiterDetail, .participantManagement:
            return TabIndex.history
        }
    }

    func makeViewController(for route: DeepLinkRoute) -> UIViewController {
        switch route {
        case .potDetail(let postID):
            return factory.makePotDetailViewController(postId: postID)
        case .participantDetail(let participationID):
            return factory.makeMyPageJoinDetailViewController(participationId: participationID)
        case .recruiterDetail(let postID):
            return factory.makeRecruitDetailViewController(postId: postID)
        case .participantManagement(let postID):
            return factory.makeParticipantManageViewController(postId: postID)
        }
    }

    func findTabBarController(from viewController: UIViewController?) -> PotiTabBar? {
        guard let viewController else { return nil }

        if let tabBarController = viewController as? PotiTabBar {
            return tabBarController
        }

        if let presentedViewController = viewController.presentedViewController,
           let tabBarController = findTabBarController(from: presentedViewController) {
            return tabBarController
        }

        if let navigationController = viewController as? UINavigationController {
            return findTabBarController(from: navigationController.visibleViewController)
        }

        return nil
    }
}
