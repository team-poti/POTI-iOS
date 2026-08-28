//
//  GetAccountUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol GetAccountUseCase {
    func execute() async throws -> AccountEntity
}

final class DefaultGetAccountUseCase: GetAccountUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute() async throws -> AccountEntity { try await repository.fetchAccount() }
}
