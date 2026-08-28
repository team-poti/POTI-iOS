//
//  DeepLinkHandler.swift
//  POTI-iOS
//
//  Created by soomin on 8/24/26.
//

import UIKit

@MainActor
final class DeepLinkHandler {

    // MARK: - Properties

    private let parser: DeepLinkParser
    private let router: DeepLinkRouter

    // MARK: - Initializer

    init(parser: DeepLinkParser, router: DeepLinkRouter) {
        self.parser = parser
        self.router = router
    }

    // MARK: - Public Methods

    func handle(_ url: URL, from rootViewController: UIViewController?) {
        guard let route = parser.parse(url) else { return }
        router.route(to: route, from: rootViewController)
    }

    func executePendingRouteIfNeeded(from rootViewController: UIViewController?) {
        router.executePendingRouteIfNeeded(from: rootViewController)
    }
}
