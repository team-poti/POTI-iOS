//
//  ViewControllerFactory.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

protocol ViewControllerFactory {
    func makeLaunchScreenViewController() -> LaunchScreenViewController
    @MainActor func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
    func makeGoodsListViewController() -> GoodsListViewController
    func makePotiTabBar() -> PotiTabBar
    func makePotDetailViewController(postId: Int) -> PotDetailViewController
}

final class DefaultViewControllerFactory: ViewControllerFactory {

    private let diContainer: AppDIContainer

    init(diContainer: AppDIContainer = .shared) {
        self.diContainer = diContainer
    }
    
    @MainActor func makeLaunchScreenViewController() -> LaunchScreenViewController {
        LaunchScreenViewController(
            viewModel: diContainer.makeLaunchScreenViewModel(), factory: self
        )
    }

    @MainActor func makeLoginViewController() -> LoginViewController {
        LoginViewController(
            viewModel: diContainer.makeLoginViewModel(), factory: self
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
    
    func makePotiTabBar() -> PotiTabBar {
        PotiTabBar(factory: self)
    }
    
    func makePotDetailViewController(postId: Int) -> PotDetailViewController {
        PotDetailViewController(
            viewModel: diContainer.makePotDetailViewModel(postId: postId)
        )
    }
}
