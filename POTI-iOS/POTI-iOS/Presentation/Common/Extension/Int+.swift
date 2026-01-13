//
//  Int+.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
