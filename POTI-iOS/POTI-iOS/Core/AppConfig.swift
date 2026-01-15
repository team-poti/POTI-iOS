//
//  AppConfig.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Foundation

enum AppConfig {

    static func baseURL() throws -> URL {
        try url(forKey: "BASE_URL")
    }

    static func kakaoAppKey() throws -> String {
        try string(forKey: "KAKAO_APP_KEY")
    }
}

private extension AppConfig {

    static func string(forKey key: String) throws -> String {
        guard
            let value = Bundle.main.object(
                forInfoDictionaryKey: key
            ) as? String,
            !value.isEmpty
        else {
            let error = PotiError.missingConfig(key: key)
            PotiLogger.error(error)
            throw error
        }

        return value
    }

    static func url(forKey key: String) throws -> URL {
        let stringValue = try string(forKey: key)

        guard let url = URL(string: stringValue) else {
            let error = PotiError.missingConfig(key: key)
            PotiLogger.error(error)
            throw error
        }

        return url
    }
}
