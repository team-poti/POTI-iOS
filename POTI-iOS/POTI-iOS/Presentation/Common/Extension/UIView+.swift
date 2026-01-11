//
//  UIView+.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
