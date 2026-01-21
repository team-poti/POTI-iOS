//
//  DevLoginUseCase.swift
//  POTI-iOS
//
//  Created by neon on 1/18/26.
//

protocol DevLoginUseCase {
    func execute() async throws -> LoginResponseEntity
}

final class DefaultDevLoginUseCase: DevLoginUseCase {

    private let repository: AuthInterface

    init(repository: AuthInterface) {
        self.repository = repository
    }

    func execute() async throws -> LoginResponseEntity {
        return try await repository.devLogin()
    }
}
