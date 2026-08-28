//
//  SettingsEntity.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

struct AccountEntity {
    let nickname: String
    let email: String?
    let socialAccount: String
}

struct ProfileManagementEntity {
    let nickname: String
    let profileImageURL: String?
}

struct AddressEntity {
    let name: String
    let postalCode: String
    let address: String
    let detailAddress: String
    let phoneNumber: String
}

enum WithdrawalAvailabilityEntity {
    case available
    case unavailable
}

struct NotificationSettingsEntity {
    let tradeNotificationEnabled: Bool
    let eventNotificationEnabled: Bool
}
