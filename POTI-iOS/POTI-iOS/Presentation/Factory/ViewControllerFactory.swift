//
//  ViewControllerFactory.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

protocol ViewControllerFactory {
    @MainActor func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
    func makeGoodsListViewController() -> GoodsListViewController
}

final class DefaultViewControllerFactory: ViewControllerFactory {

    private let diContainer: AppDIContainer

    init(diContainer: AppDIContainer = .shared) {
        self.diContainer = diContainer
    }

    @MainActor func makeLoginViewController() -> LoginViewController {
        LoginViewController(
            viewModel: diContainer.makeLoginViewModel()
        )
    }
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController(
            viewModel: diContainer.makeHomeViewModel()
        )
    }
    
    func makeGoodsListViewController() -> GoodsListViewController {
        GoodsListViewController(
            viewModel: diContainer.makeGoodsListViewModel()
        )
    }
}
