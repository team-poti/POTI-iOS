//
//  LoginUseCase.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

protocol LoginUseCase {
    func execute(socialType: String, token: String) async throws -> LoginResponseEntity
}

final class DefaultLoginUseCase: LoginUseCase {

    private let repository: AuthInterface

    init(repository: AuthInterface) {
        self.repository = repository
    }

    func execute(socialType: String, token: String) async throws -> LoginResponseEntity {
        return try await repository.login(socialType: socialType, token: token)
    }
}
