//
//  PotiNavigationController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

final class PotiNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: PotiHeightNavigationBar.self, toolbarClass: nil)
        setViewControllers([rootViewController], animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private final class PotiHeightNavigationBar: UINavigationBar {
    private let customHeight: CGFloat = 56

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var navigationBarSize = super.sizeThatFits(size)
        navigationBarSize.height = customHeight
        return navigationBarSize
    }
}
