//
//  Date+.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

import Foundation

extension Date {
    func toYMDString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}
