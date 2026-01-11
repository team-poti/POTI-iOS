//
//  LoginViewModel.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

final class LoginViewModel {

    // MARK: - Input
    enum Input {
        case didTapLogin
    }

    // MARK: - Output
    enum Output {
        case loginSuccess
        case loginFailure
    }

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func handle(input: Input) -> Output {
        switch input {
        case .didTapLogin:
            let success = loginUseCase.execute()
            return success ? .loginSuccess : .loginFailure
        }
    }
}
