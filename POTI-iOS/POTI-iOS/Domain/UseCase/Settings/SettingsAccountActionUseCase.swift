//
//  SettingsAccountActionUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol SettingsAccountActionUseCase {
    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity
    func withdraw(reason: String) async throws
    func logout() async throws
}

final class DefaultSettingsAccountActionUseCase: SettingsAccountActionUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity { try await repository.withdrawalAvailability() }
    func withdraw(reason: String) async throws { try await repository.withdraw(reason: reason) }
    func logout() async throws { try await repository.logout() }
}
