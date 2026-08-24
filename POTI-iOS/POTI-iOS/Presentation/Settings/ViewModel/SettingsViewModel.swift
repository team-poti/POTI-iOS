//
//  SettingsViewModel.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import Combine
import Foundation

final class SettingsViewModel: BaseViewModelType {
    enum Input {
        case fetchAccount
        case fetchProfile
        case fetchAddress
        case updateProfile(nickname: String, profileImageURL: String?)
        case updateProfileImage(nickname: String, imageData: Data)
        case updateAddress(AddressEntity)
        case fetchNotificationSettings
        case updateNotificationSettings(tradeEnabled: Bool, eventEnabled: Bool)
        case checkWithdrawal
        case withdraw(String)
        case logout
    }

    struct Output {
        let account: AnyPublisher<AccountEntity, Never>
        let profile: AnyPublisher<ProfileManagementEntity, Never>
        let address: AnyPublisher<AddressEntity, Never>
        let withdrawalAvailability: AnyPublisher<WithdrawalAvailabilityEntity, Never>
        let notificationSettings: AnyPublisher<NotificationSettingsEntity, Never>
        let completed: AnyPublisher<Void, Never>
        let error: AnyPublisher<String, Never>
    }

    let output: Output

    private let accountSubject = PassthroughSubject<AccountEntity, Never>()
    private let profileSubject = PassthroughSubject<ProfileManagementEntity, Never>()
    private let addressSubject = PassthroughSubject<AddressEntity, Never>()
    private let withdrawalSubject = PassthroughSubject<WithdrawalAvailabilityEntity, Never>()
    private let notificationSettingsSubject = PassthroughSubject<NotificationSettingsEntity, Never>()
    private let completedSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    private let getAccountUseCase: GetAccountUseCase
    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase
    private let getAddressUseCase: GetAddressUseCase
    private let updateAddressUseCase: UpdateAddressUseCase
    private let getNotificationSettingsUseCase: GetNotificationSettingsUseCase
    private let updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase
    private let accountActionUseCase: SettingsAccountActionUseCase

    init(
        getAccountUseCase: GetAccountUseCase,
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        getAddressUseCase: GetAddressUseCase,
        updateAddressUseCase: UpdateAddressUseCase,
        getNotificationSettingsUseCase: GetNotificationSettingsUseCase,
        updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase,
        accountActionUseCase: SettingsAccountActionUseCase
    ) {
        self.getAccountUseCase = getAccountUseCase
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.getAddressUseCase = getAddressUseCase
        self.updateAddressUseCase = updateAddressUseCase
        self.getNotificationSettingsUseCase = getNotificationSettingsUseCase
        self.updateNotificationSettingsUseCase = updateNotificationSettingsUseCase
        self.accountActionUseCase = accountActionUseCase
        output = Output(
            account: accountSubject.eraseToAnyPublisher(),
            profile: profileSubject.eraseToAnyPublisher(),
            address: addressSubject.eraseToAnyPublisher(),
            withdrawalAvailability: withdrawalSubject.eraseToAnyPublisher(),
            notificationSettings: notificationSettingsSubject.eraseToAnyPublisher(),
            completed: completedSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }

    func action(_ trigger: Input) {
        Task {
            do {
                switch trigger {
                case .fetchAccount:
                    accountSubject.send(try await getAccountUseCase.execute())
                case .fetchProfile:
                    profileSubject.send(try await getProfileUseCase.execute())
                case .fetchAddress:
                    addressSubject.send(try await getAddressUseCase.execute())
                case .updateProfile(let nickname, let profileImageURL):
                    profileSubject.send(try await updateProfileUseCase.execute(nickname: nickname, profileImageURL: profileImageURL))
                    completedSubject.send(())
                case .updateProfileImage(let nickname, let imageData):
                    let fileName = try await uploadProfileImageUseCase.execute(imageData: imageData)
                    _ = try await updateProfileUseCase.execute(nickname: nickname, profileImageURL: fileName)
                    completedSubject.send(())
                case .updateAddress(let address):
                    addressSubject.send(try await updateAddressUseCase.execute(address))
                    completedSubject.send(())
                case .fetchNotificationSettings:
                    notificationSettingsSubject.send(try await getNotificationSettingsUseCase.execute())
                case .updateNotificationSettings(let tradeEnabled, let eventEnabled):
                    notificationSettingsSubject.send(
                        try await updateNotificationSettingsUseCase.execute(
                            tradeEnabled: tradeEnabled,
                            eventEnabled: eventEnabled
                        )
                    )
                case .checkWithdrawal:
                    withdrawalSubject.send(try await accountActionUseCase.withdrawalAvailability())
                case .withdraw(let reason):
                    try await accountActionUseCase.withdraw(reason: reason)
                    completedSubject.send(())
                case .logout:
                    try await accountActionUseCase.logout()
                    completedSubject.send(())
                }
            } catch {
                errorSubject.send("요청을 처리하지 못했습니다.")
            }
        }
    }
}
