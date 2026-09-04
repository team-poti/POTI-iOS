//
//  Date+.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

import Foundation

extension Date {
    func toYMDString() -> String {
        DateFormatter.ymd.string(from: self)
    }
}

private extension DateFormatter {
    static let ymd = make(dateFormat: "yyyy-MM-dd")

    static func make(dateFormat: String, locale: String = "ko_KR", timeZone: String = "Asia/Seoul") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: locale)
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter
    }
}
