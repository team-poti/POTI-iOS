//
//  PushNotificationPayload.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import Foundation

struct PushNotificationPayload {

    // MARK: - Properties

    let deepLink: URL?
    let notificationId: Int?

    // MARK: - Initializer

    init(userInfo: [AnyHashable: Any]) {
        deepLink = Self.nonEmptyString(userInfo["deeplink"]).flatMap(URL.init(string:))
        notificationId = Self.intValue(userInfo["notificationId"])
    }

    // MARK: - Private Methods

    private static func nonEmptyString(_ value: Any?) -> String? {
        guard let string = value as? String else { return nil }

        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.isEmpty ? nil : trimmedString
    }

    private static func intValue(_ value: Any?) -> Int? {
        if let number = value as? NSNumber {
            return number.intValue
        }

        return nonEmptyString(value).flatMap(Int.init)
    }
}
