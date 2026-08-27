//
//  SettingsViewModel.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import Combine
import Foundation

final class SettingsViewModel: BaseViewModelType {
    enum ProfileError {
        case fetch(String)
        case update(String)
    }

    enum Input {
        case fetchAccount
        case fetchProfile
        case fetchAddress
        case updateProfile(nickname: String, profileImageURL: String?)
        case updateProfileImage(nickname: String, image: UploadImageEntity)
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
        let logoutCompleted: AnyPublisher<Void, Never>
        let withdrawalCompleted: AnyPublisher<Void, Never>
        let profileError: AnyPublisher<ProfileError, Never>
        let error: AnyPublisher<String, Never>
    }

    let output: Output

    private let accountSubject = PassthroughSubject<AccountEntity, Never>()
    private let profileSubject = PassthroughSubject<ProfileManagementEntity, Never>()
    private let addressSubject = PassthroughSubject<AddressEntity, Never>()
    private let withdrawalSubject = PassthroughSubject<WithdrawalAvailabilityEntity, Never>()
    private let notificationSettingsSubject = PassthroughSubject<NotificationSettingsEntity, Never>()
    private let completedSubject = PassthroughSubject<Void, Never>()
    private let logoutCompletedSubject = PassthroughSubject<Void, Never>()
    private let withdrawalCompletedSubject = PassthroughSubject<Void, Never>()
    private let profileErrorSubject = PassthroughSubject<ProfileError, Never>()
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
    private let withdrawUseCase: WithdrawUseCase
    private let logoutUseCase: LogoutUseCase

    init(
        getAccountUseCase: GetAccountUseCase,
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        getAddressUseCase: GetAddressUseCase,
        updateAddressUseCase: UpdateAddressUseCase,
        getNotificationSettingsUseCase: GetNotificationSettingsUseCase,
        updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase,
        accountActionUseCase: SettingsAccountActionUseCase,
        withdrawUseCase: WithdrawUseCase,
        logoutUseCase: LogoutUseCase
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
        self.withdrawUseCase = withdrawUseCase
        self.logoutUseCase = logoutUseCase
        output = Output(
            account: accountSubject.eraseToAnyPublisher(),
            profile: profileSubject.eraseToAnyPublisher(),
            address: addressSubject.eraseToAnyPublisher(),
            withdrawalAvailability: withdrawalSubject.eraseToAnyPublisher(),
            notificationSettings: notificationSettingsSubject.eraseToAnyPublisher(),
            completed: completedSubject.eraseToAnyPublisher(),
            logoutCompleted: logoutCompletedSubject.eraseToAnyPublisher(),
            withdrawalCompleted: withdrawalCompletedSubject.eraseToAnyPublisher(),
            profileError: profileErrorSubject.eraseToAnyPublisher(),
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
                case .updateProfileImage(let nickname, let image):
                    let fileName = try await uploadProfileImageUseCase.execute(image: image)
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
                    try await withdrawUseCase.execute(reason: reason)
                    withdrawalCompletedSubject.send(())
                case .logout:
                    try await logoutUseCase.execute()
                    logoutCompletedSubject.send(())
                }
            } catch {
                let message = "요청을 처리하지 못했습니다."

                switch trigger {
                case .fetchProfile:
                    profileErrorSubject.send(.fetch(message))
                case .updateProfile, .updateProfileImage:
                    profileErrorSubject.send(.update(message))
                default:
                    errorSubject.send(message)
                }
            }
        }
    }
}
