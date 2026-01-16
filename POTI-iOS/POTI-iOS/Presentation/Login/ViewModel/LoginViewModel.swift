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
    }

    // MARK: - Output
    
    struct Output {
        let loginSuccess: AnyPublisher<Void, Never>
        let loginFailure: AnyPublisher<Error, Never>
    }

    private(set) var output: Output
    
    // MARK: - Subjects
    
    private let loginSuccessSubject = PassthroughSubject<Void, Never>()
    private let loginFailureSubject = PassthroughSubject<Error, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let loginUseCase: LoginUseCase

    init(
        loginUseCase: LoginUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.output = Output(
            loginSuccess: loginSuccessSubject.eraseToAnyPublisher(),
            loginFailure: loginFailureSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginTap:
            kakaoLogin()
        }
    }
    
    private func kakaoLogin() {
        Task {
            do {
                _ = try await loginUseCase.execute(socialType: "KAKAO")
                loginSuccessSubject.send(())
            } catch {
                PotiLogger.error(error)
                loginFailureSubject.send(error)
            }
        }
    }
}
