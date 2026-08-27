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
        case appleLoginTap
    }

    // MARK: - Output
    
    struct Output {
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let navigateToHome: AnyPublisher<Void, Never>
        let loginFailure: AnyPublisher<Error, Never>
    }
    
    private(set) var output: Output
    
    // MARK: - Subjects
    
    private let navigateToOnboardingSubject = PassthroughSubject<Void, Never>()
    private let navigateToHomeSubject = PassthroughSubject<Void, Never>()
    private let loginFailureSubject = PassthroughSubject<Error, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        self.output = Output(
            navigateToOnboarding: navigateToOnboardingSubject.eraseToAnyPublisher(),
            navigateToHome: navigateToHomeSubject.eraseToAnyPublisher(),
            loginFailure: loginFailureSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginTap:
            login(type: .kakao)
        case .appleLoginTap:
            login(type: .apple)
        }
    }
    
    private func login(type: SocialLoginType) {
        Task {
            do {
                let result = try await loginUseCase.execute(type: type)
                if result.isNewUser {
                    navigateToOnboardingSubject.send(())
                } else {
                    navigateToHomeSubject.send(())
                }
            } catch {
                guard !(error is CancellationError) else { return }
                PotiLogger.error(error)
                loginFailureSubject.send(error)
            }
        }
    }
}
