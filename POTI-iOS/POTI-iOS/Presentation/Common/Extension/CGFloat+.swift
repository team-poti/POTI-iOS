//
//  CGFloat+.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

extension CGFloat {
    static func dynamicH(_ value: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return value * (screenHeight / 812)
    }
}
