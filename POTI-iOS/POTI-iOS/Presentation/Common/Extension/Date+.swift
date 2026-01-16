//
//  Date+.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import Foundation

extension Date {
    
    func toKoreanYMD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}
