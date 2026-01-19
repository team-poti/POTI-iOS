//
//  LaunchScreenViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

import Combine

final class LaunchScreenViewModel: BaseViewModelType {
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let navigationDestination: AnyPublisher<NavigationDestination, Never>
    }
        
    enum NavigationDestination {
        case tabBar
        case login
    }
    
    private(set) var output: Output
    
    private let navigationSubject = PassthroughSubject<NavigationDestination, Never>()
    private var cancellables = Set<AnyCancellable>()
        
    private let refreshTokenUseCase: RefreshTokenUseCase
        
    init(refreshTokenUseCase: RefreshTokenUseCase) {
        self.refreshTokenUseCase = refreshTokenUseCase
        self.output = Output(
            navigationDestination: navigationSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            checkAuthStatus()
        }
    }
        
    private func checkAuthStatus() {
        let hasAccessToken = KeychainManager.getAccessToken() != nil
        let hasRefreshToken = KeychainManager.getRefreshToken() != nil
        
        if hasAccessToken && hasRefreshToken {
            refreshAndNavigate()
        } else {
            navigationSubject.send(.login)
        }
    }
    
    private func refreshAndNavigate() {
        Task {
            do {
                let tokenEntity = try await refreshTokenUseCase.execute()
                
                // Keychain 저장
                KeychainManager.saveTokens(
                    accessToken: tokenEntity.accessToken,
                    refreshToken: tokenEntity.refreshToken
                )
                
                await MainActor.run {
                    navigationSubject.send(.tabBar)
                }
                
            } catch {
                await MainActor.run {
                    KeychainManager.deleteAllTokens()
                    navigationSubject.send(.login)
                    PotiLogger.error(error)
                }
            }
        }
    }
}
