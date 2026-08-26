//
//  PushNotificationPayload.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import Foundation

struct PushNotificationPayload {

    // MARK: - Properties

    let title: String?
    let body: String?
    let deepLink: URL?

    // MARK: - Initializer

    init(userInfo: [AnyHashable: Any]) {
        title = Self.nonEmptyString(userInfo["title"])
        body = Self.nonEmptyString(userInfo["body"])
        deepLink = Self.nonEmptyString(userInfo["deeplink"]).flatMap(URL.init(string:))
    }

    // MARK: - Private Methods

    private static func nonEmptyString(_ value: Any?) -> String? {
        guard let string = value as? String else { return nil }

        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.isEmpty ? nil : trimmedString
    }
}
