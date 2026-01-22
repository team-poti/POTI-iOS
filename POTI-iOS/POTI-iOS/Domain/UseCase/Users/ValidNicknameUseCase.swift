//
//  ValidNicknameUseCase.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

protocol ValidNicknameUseCase {
    func execute(_ nickname: String) async throws -> Bool
}

final class DefaultValidNicknameUseCase: ValidNicknameUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(_ nickname: String) async throws -> Bool {
        return try await repository.validateNickname(nickname)
    }
}
