//
//  String+.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import Foundation

extension String {

    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: self)!
    }
    
    func toKoreanYMD() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return outputFormatter.string(from: date)
    }
    
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        formatter.dateFormat = "yyyy-MM-dd H:mm"
        return formatter.string(from: date)
    }

    func toRelativeTime(now: Date = Date()) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: self) else { return "" }
        let elapsedSeconds = max(0, Int(now.timeIntervalSince(date)))

        switch elapsedSeconds {
        case ..<60:
            return "방금 전"
        case ..<3600:
            return "\(elapsedSeconds / 60)분 전"
        case ..<86400:
            return "\(elapsedSeconds / 3600)시간 전"
        case ..<604800:
            return "\(elapsedSeconds / 86400)일 전"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            return dateFormatter.string(from: date)
        }
    }
}
