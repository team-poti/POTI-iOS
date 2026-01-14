//
//  LoginViewModel.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import Combine

final class LoginViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let kakaoLoginTap: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    
    struct Output {
        let loginSuccess: AnyPublisher<Void, Never>
        let loginFailure: AnyPublisher<Void, Never>
    }

    private let loginUseCase: LoginUseCase
    private let authService: AuthService
    
    // MARK: - Subjects
    
    private let loginSuccessSubject = PassthroughSubject<Void, Never>()
    private let loginFailureSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(
        loginUseCase: LoginUseCase,
        authService: AuthService
    ) {
        self.loginUseCase = loginUseCase
        self.authService = authService
    }
    
    func transform(input: Input) -> Output {
        input.kakaoLoginTap
            .sink { [weak self] in
                self?.kakaoLogin()
            }
            .store(in: &cancellables)
        
        return Output(
            loginSuccess: loginSuccessSubject.eraseToAnyPublisher(),
            loginFailure: loginFailureSubject.eraseToAnyPublisher()
        )
    }
    
    private func kakaoLogin() {
        Task {
            do {
                let kakaoToken = try await authService.kakaoRequest()
                _ = try await loginUseCase.execute(socialType: "KAKAO", token: kakaoToken)
                loginSuccessSubject.send(())
            } catch {
                PotiLogger.error(error)
                loginFailureSubject.send(())
            }
        }
    }
}
