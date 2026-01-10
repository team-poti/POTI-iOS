//
//  UIStackView+.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
