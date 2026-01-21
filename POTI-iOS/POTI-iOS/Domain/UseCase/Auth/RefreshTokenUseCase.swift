//
//  RefreshToken.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

protocol RefreshTokenUseCase {
    func execute() async throws
}

final class DefaultRefreshTokenUseCase: RefreshTokenUseCase {
    
    private let repository: AuthInterface

    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.refreshToken()
    }
}
