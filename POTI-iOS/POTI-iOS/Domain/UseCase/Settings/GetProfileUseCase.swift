//
//  GetProfileUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/24/26.
//

protocol GetProfileUseCase {
    func execute() async throws -> ProfileManagementEntity
}

final class DefaultGetProfileUseCase: GetProfileUseCase {
    private let repository: SettingsInterface

    init(repository: SettingsInterface) {
        self.repository = repository
    }

    func execute() async throws -> ProfileManagementEntity {
        try await repository.fetchProfile()
    }
}
