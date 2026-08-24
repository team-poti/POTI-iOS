//
//  SettingsAPI.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import Alamofire

enum SettingsAPI: BaseTargetType {
    case account
    case updateProfile(nickname: String, profileImageURL: String?)
    case address
    case updateAddress(AddressEntity)
    case notificationSettings
    case updateNotificationSettings(tradeEnabled: Bool, eventEnabled: Bool)

    var path: String {
        switch self {
        case .account: return "/api/v1/users/me/account"
        case .updateProfile: return "/api/v1/users/me/profile"
        case .address, .updateAddress: return "/api/v1/users/me/address"
        case .notificationSettings, .updateNotificationSettings: return "/api/v1/notifications/settings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .account, .address, .notificationSettings: return .get
        case .updateProfile, .updateAddress, .updateNotificationSettings: return .patch
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .updateProfile(let nickname, let profileImageURL):
            var parameters: Parameters = ["nickname": nickname]
            parameters["profileImageUrl"] = profileImageURL
            return parameters
        case .updateAddress(let address):
            let addressLine = [address.address, address.detailAddress]
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .joined(separator: " ")
            return [
                "receiverName": address.name,
                "zipcode": address.postalCode,
                "addressLine": addressLine,
                "phone": address.phoneNumber
            ]
        case .updateNotificationSettings(let tradeEnabled, let eventEnabled):
            return [
                "tradeNotificationEnabled": tradeEnabled,
                "eventNotificationEnabled": eventEnabled
            ]
        case .account, .address, .notificationSettings:
            return nil
        }
    }
}
