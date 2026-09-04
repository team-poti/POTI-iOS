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
        StringDateFormatter.ymd.date(from: self)!
    }
    
    func toKoreanYMD() -> String? {
        guard let date = StringDateFormatter.ymd.date(from: self) else {
            return nil
        }

        return StringDateFormatter.koreanYMD.string(from: date)
    }
    
    func formattedDateString() -> String {
        guard let date = StringDateFormatter.dateTimeWithoutSeconds.date(from: self) else {
            return ""
        }

        return StringDateFormatter.readableDateTime.string(from: date)
    }

    func toRelativeTime(now: Date = Date()) -> String {
        guard let date = StringDateFormatter.iso8601Fractional.date(from: self) ?? StringDateFormatter.iso8601.date(from: self)
                    ?? StringDateFormatter.localDateTimeFractional.date(from: self) ?? StringDateFormatter.localDateTime.date(from: self) else { return "" }
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
            return StringDateFormatter.monthDay.string(from: date)
        }
    }
}

private enum StringDateFormatter {
    static let ymd = make("yyyy-MM-dd")
    static let koreanYMD = make("yyyy년 M월 d일")
    static let dateTimeWithoutSeconds = make("yyyy-MM-dd'T'HH:mm", timeZone: .current)
    static let readableDateTime = make("yyyy-MM-dd H:mm", timeZone: .current)
    static let localDateTimeFractional = make("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", locale: "en_US_POSIX")
    static let localDateTime = make("yyyy-MM-dd'T'HH:mm:ss", locale: "en_US_POSIX")
    static let monthDay = make("MM.dd")

    static let iso8601Fractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static func make(_ format: String, locale: String = "ko_KR", timeZone: TimeZone? = TimeZone(identifier: "Asia/Seoul")) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)
        formatter.timeZone = timeZone
        return formatter
    }
}
