//
//  LoginViewModel.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Combine

final class LoginViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case kakaoLoginTap
        case devLoginTap
    }

    // MARK: - Output
    
    struct Output {
        let loginSuccess: AnyPublisher<LoginSuccessType, Never>
        let loginFailure: AnyPublisher<Error, Never>
    }
    
    enum LoginSuccessType {
        case kakao
        case dev
    }

    private(set) var output: Output
    
    // MARK: - Subjects
    
    private let loginSuccessSubject = PassthroughSubject<LoginSuccessType, Never>()
    private let loginFailureSubject = PassthroughSubject<Error, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let loginUseCase: LoginUseCase
    private let devLoginUseCase: DevLoginUseCase

    init(
        loginUseCase: LoginUseCase,
        devLoginUseCase: DevLoginUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.devLoginUseCase = devLoginUseCase
        self.output = Output(
            loginSuccess: loginSuccessSubject.eraseToAnyPublisher(),
            loginFailure: loginFailureSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginTap:
            kakaoLogin()
        case .devLoginTap:
            devLogin()
        }
    }
    
    private func kakaoLogin() {
        Task {
            do {
                _ = try await loginUseCase.execute(socialType: "KAKAO")
                loginSuccessSubject.send(.kakao)
            } catch {
                PotiLogger.error(error)
                loginFailureSubject.send(error)
            }
        }
    }
    
    private func devLogin() {
        Task {
            do {
                _ = try await devLoginUseCase.execute()
                loginSuccessSubject.send(.dev)
            } catch {
                PotiLogger.error(error)
                loginFailureSubject.send(error)
            }
        }
    }
}
