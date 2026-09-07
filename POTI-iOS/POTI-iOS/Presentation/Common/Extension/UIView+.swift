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

    var firstResponder: UIView? {
        if isFirstResponder { return self }
        return subviews.lazy.compactMap(\.firstResponder).first
    }
}
