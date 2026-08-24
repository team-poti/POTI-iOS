//
//  SettingsAccountActionUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol SettingsAccountActionUseCase {
    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity
}

final class DefaultSettingsAccountActionUseCase: SettingsAccountActionUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func withdrawalAvailability() async throws -> WithdrawalAvailabilityEntity { try await repository.withdrawalAvailability() }
}
