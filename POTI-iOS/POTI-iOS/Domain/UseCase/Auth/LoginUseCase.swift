//
//  LoginUseCase.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

protocol LoginUseCase {
    func execute() -> Bool
}

final class DefaultLoginUseCase: LoginUseCase {

    private let repository: AuthInterface

    init(repository: AuthInterface) {
        self.repository = repository
    }

    func execute() -> Bool {
        repository.login()
    }
}
