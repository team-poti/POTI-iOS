//
//  SettingsInterface.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol SettingsInterface {
    func fetchAccount() async throws -> AccountEntity
    func fetchProfile() async throws -> ProfileManagementEntity
    func fetchAddress() async throws -> AddressEntity
    func updateProfile(nickname: String, profileImageURL: String?) async throws -> ProfileManagementEntity
    func updateAddress(_ address: AddressEntity) async throws -> AddressEntity
    func fetchNotificationSettings() async throws -> NotificationSettingsEntity
    func updateNotificationSettings(tradeEnabled: Bool, eventEnabled: Bool) async throws -> NotificationSettingsEntity
    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity
}
