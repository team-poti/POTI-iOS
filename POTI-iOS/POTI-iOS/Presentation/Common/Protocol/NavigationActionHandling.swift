//
//  NavigationActionHandling.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

@objc public protocol NavigationActionHandling: AnyObject {
    func navigationButtonTapped(_ sender: UIButton)
}
