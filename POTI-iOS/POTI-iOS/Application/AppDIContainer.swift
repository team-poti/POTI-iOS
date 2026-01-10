//
//  AppDIContainer.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

final class AppDIContainer {

    static let shared = AppDIContainer()
    private init() {}

    // MARK: - Repository
    private func makeAuthRepository() -> AuthInterface {
        DefaultAuthRepository()
    }

    // MARK: - UseCase
    private func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(
            repository: makeAuthRepository()
        )
    }

    // MARK: - ViewModel
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            loginUseCase: makeLoginUseCase()
        )
    }
}
