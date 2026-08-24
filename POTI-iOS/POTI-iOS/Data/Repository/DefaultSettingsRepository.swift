//
//  DefaultSettingsRepository.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

final class DefaultSettingsRepository: SettingsInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchAccount() async throws -> AccountEntity {
        try await networkService.request(target: SettingsAPI.account, type: AccountResponseDTO.self).toEntity()
    }

    func fetchProfile() async throws -> ProfileManagementEntity {
        let profile = try await networkService.request(
            target: UsersAPI.getMyPageInformation,
            type: MyPageResponseDTO.self
        )
        return ProfileManagementEntity(
            nickname: profile.nickname,
            profileImageURL: profile.profileImageUrl
        )
    }

    func fetchAddress() async throws -> AddressEntity {
        try await networkService.request(target: SettingsAPI.address, type: AddressResponseDTO.self).toEntity()
    }

    func updateProfile(nickname: String, profileImageURL: String?) async throws -> ProfileManagementEntity {
        _ = try await networkService.request(
            target: SettingsAPI.updateProfile(nickname: nickname, profileImageURL: profileImageURL),
            type: EmptyResponse.self
        )
        return ProfileManagementEntity(nickname: nickname, profileImageURL: profileImageURL)
    }

    func updateAddress(_ address: AddressEntity) async throws -> AddressEntity {
        _ = try await networkService.request(target: SettingsAPI.updateAddress(address), type: EmptyResponse.self)
        return address
    }

    func fetchNotificationSettings() async throws -> NotificationSettingsEntity {
        try await networkService.request(
            target: SettingsAPI.notificationSettings,
            type: NotificationSettingsResponseDTO.self
        ).toEntity()
    }

    func updateNotificationSettings(tradeEnabled: Bool, eventEnabled: Bool) async throws -> NotificationSettingsEntity {
        try await networkService.request(
            target: SettingsAPI.updateNotificationSettings(tradeEnabled: tradeEnabled, eventEnabled: eventEnabled),
            type: NotificationSettingsResponseDTO.self
        ).toEntity()
    }

    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity { .available }
    func withdraw(reason: String) async throws {}
    func logout() async throws {}
}
