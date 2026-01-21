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
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let navigateToHome: AnyPublisher<Void, Never>
        let loginFailure: AnyPublisher<Error, Never>
    }
    
    enum LoginSuccessType {
        case kakao
        case dev
    }

    private(set) var output: Output
    
    // MARK: - Subjects
    
    private let navigateToOnboardingSubject = PassthroughSubject<Void, Never>()
    private let navigateToHomeSubject = PassthroughSubject<Void, Never>()
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
            navigateToOnboarding: navigateToOnboardingSubject.eraseToAnyPublisher(),
            navigateToHome: navigateToHomeSubject.eraseToAnyPublisher(),
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
                let result = try await loginUseCase.execute(socialType: "KAKAO")
                if result.isNewUser {
                    navigateToOnboardingSubject.send(())
                } else {
                    navigateToHomeSubject.send(())
                }
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
                navigateToHomeSubject.send(())
            } catch {
                PotiLogger.error(error)
                loginFailureSubject.send(error)
            }
        }
    }
}
