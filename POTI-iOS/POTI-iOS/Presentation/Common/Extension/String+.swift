//
//  String+.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import Foundation

extension String {
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: self)!
    }
}
