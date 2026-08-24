//
//  UpdateProfileUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol UpdateProfileUseCase {
    func execute(nickname: String, profileImageURL: String?) async throws -> ProfileManagementEntity
}

final class DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute(nickname: String, profileImageURL: String?) async throws -> ProfileManagementEntity {
        try await repository.updateProfile(nickname: nickname, profileImageURL: profileImageURL)
    }
}
