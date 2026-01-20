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
    
    private func makeNetworkService() -> NetworkService {
        NetworkService()
    }
    
    // MARK: - Repository
    
    @MainActor private func makeAuthRepository() -> AuthInterface {
        DefaultAuthRepository(authService: makeAuthService(), networkService: makeNetworkService())
    }
    
    private func makeHomeRepository() -> HomeInterface {
        DefaultHomeRepository()
    }
    
    private func makeGoodsListRepository() -> GoodsListInterface {
        DefaultGoodsListRepository()
    }
    
    private func makeOrderRepository() -> OrderInterface {
        DefaultOrderRepository()
    }
    
    // MARK: - UseCase
    
    @MainActor private func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(
            repository: makeAuthRepository()
        )
    }
    
    @MainActor private func makeDevLoginUseCase() -> DevLoginUseCase {
        DefaultDevLoginUseCase(
            repository: makeAuthRepository()
        )
    }
    
    private func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(repository: makeHomeRepository())
    }
    
    private func makeGoodsListUseCase() -> GoodsListUseCase {
        DefaultGoodsListUseCase(repository: makeGoodsListRepository())
    }
    
    private func makeOrderUseCase() -> OrderUseCase {
        DefaultOrderUseCase(repository: makeOrderRepository())
    }
    
    // MARK: - ViewModel
    
    @MainActor func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase(), devLoginUseCase: makeDevLoginUseCase())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeHomeUseCase())
    }
    
    func makeGoodsListViewModel() -> GoodsListViewModel {
        GoodsListViewModel(useCase: makeGoodsListUseCase())
    }
    
    func makeOrderViewModel() -> OrderViewModel {
        OrderViewModel(useCase: makeOrderUseCase())
    }
}
