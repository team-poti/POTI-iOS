//
//  Int+.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

extension Int {
    var formattedWithComma: String {
        Self.decimalFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
 }
