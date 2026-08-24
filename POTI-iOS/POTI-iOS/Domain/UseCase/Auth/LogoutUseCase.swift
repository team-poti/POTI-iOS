//
//  LogoutUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/24/26.
//

protocol LogoutUseCase {
    func execute() async throws
}

final class DefaultLogoutUseCase: LogoutUseCase {
    private let repository: AuthInterface

    init(repository: AuthInterface) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.logout()
    }
}
