//
//  FCMTokenStore.swift
//  POTI-iOS
//
//  Created by soomin on 8/25/26.
//

import Foundation

protocol FCMTokenStore: AnyObject {
    var token: String? { get }

    func save(_ token: String)
    func clear()
}

final class UserDefaultsFCMTokenStore: FCMTokenStore {

    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let tokenKey = "fcmToken"

    var token: String? {
        userDefaults.string(forKey: tokenKey)
    }

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Methods

    func save(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }

    func clear() {
        userDefaults.removeObject(forKey: tokenKey)
    }
}
