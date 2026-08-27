//
//  MockSettingsRepository.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

final class MockSettingsRepository: SettingsInterface {
    private var profile = ProfileManagementEntity(
        nickname: "이포티",
        profileImageURL: nil
    )

    private var address = AddressEntity(
        name: "이수민",
        postalCode: "06134",
        address: "서울특별시 강남구 테헤란로",
        detailAddress: "포티빌딩 17층",
        phoneNumber: "010-1234-5678"
    )

    /// 탈퇴 불가 화면 확인 시 `.unavailable`로 변경합니다.
    var withdrawalState: WithdrawalAvailabilityEntity = .available

    func fetchAccount() async throws -> AccountEntity {
        AccountEntity(nickname: "이수민", email: "poti@gmail.com", socialAccount: "카카오톡")
    }

    func fetchProfile() async throws -> ProfileManagementEntity { profile }
    func fetchAddress() async throws -> AddressEntity { address }

    func updateProfile(nickname: String, profileImageURL: String?) async throws -> ProfileManagementEntity {
        profile = ProfileManagementEntity(
            nickname: nickname,
            profileImageURL: profileImageURL ?? profile.profileImageURL
        )
        return profile
    }

    func updateAddress(_ address: AddressEntity) async throws -> AddressEntity {
        self.address = address
        return address
    }

    func fetchNotificationSettings() async throws -> NotificationSettingsEntity {
        NotificationSettingsEntity(tradeNotificationEnabled: true, eventNotificationEnabled: false)
    }

    func updateNotificationSettings(tradeEnabled: Bool, eventEnabled: Bool) async throws -> NotificationSettingsEntity {
        NotificationSettingsEntity(
            tradeNotificationEnabled: tradeEnabled,
            eventNotificationEnabled: eventEnabled
        )
    }

    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity {
        withdrawalState
    }
}
