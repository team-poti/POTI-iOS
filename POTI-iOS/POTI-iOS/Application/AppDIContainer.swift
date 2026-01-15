//
//  AppDIContainer.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    private init() {}
    
    // MARK: - Service
    
    @MainActor private func makeAuthService() -> AuthService {
        DefaultAuthService()
    }
    
    // MARK: - Repository
    
    private func makeAuthRepository() -> AuthInterface {
        DefaultAuthRepository()
    }
    
    private func makeHomeRepository() -> HomeInterface {
        DefaultHomeRepository()
    }
    
    private func makeGoodsListRepository() -> GoodsListInterface {
        DefaultGoodsListRepository()
    }
    
    // MARK: - UseCase
    
    private func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(
            repository: makeAuthRepository()
        )
    }
    
    private func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(repository: makeHomeRepository())
    }
    
    private func makeGoodsListUseCase() -> GoodsListUseCase {
        DefaultGoodsListUseCase(repository: makeGoodsListRepository())
    }
    
    // MARK: - ViewModel
    
    @MainActor func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            loginUseCase: makeLoginUseCase(),
            authService: makeAuthService()
        )
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeHomeUseCase())
    }
    
    func makeGoodsListViewModel() -> GoodsListViewModel {
        GoodsListViewModel(useCase: makeGoodsListUseCase())
    }
}
