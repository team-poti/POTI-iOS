//
//  ViewControllerFactory.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

protocol ViewControllerFactory {
    func makeLaunchScreenViewController() -> LaunchScreenViewController
    @MainActor func makeLoginViewController() -> LoginViewController
    func makePotiTabBar() -> PotiTabBar
    func makeHomeViewController() -> HomeViewController
    func makeGoodsListViewController() -> GoodsListViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeOrderSheetViewController() -> OrderSheetViewController
    func makePotDetailViewController(postId: Int) -> PotDetailViewController
    func makeOnboardingViewController() -> OnboardingViewController
    func makeValidNicknameViewController() -> ValidNicknameViewController
    func makeSelectFavoriteIdolGroupViewController() -> SelectFavoriteIdolGroupViewController
    func makeRecruitDetailViewController() -> RecruitDetailViewController
    func makeParticipantManageViewController() -> ParticipantListTableViewController
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController
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
    
    func makePotiTabBar() -> PotiTabBar {
        PotiTabBar(factory: self)
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
  
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(
            viewModel: MyPageViewModel()
        )
    }
    
    func makeOrderSheetViewController() -> OrderSheetViewController {
        OrderSheetViewController(
            viewModel: diContainer.makeOrderViewModel()
        )
    }
    
    func makeRecruitDetailViewController() -> RecruitDetailViewController {
        RecruitDetailViewController(viewModel: diContainer.makeRecruitDetailViewModel())
    }
    
    func makeParticipantManageViewController() -> ParticipantListTableViewController {
        ParticipantListTableViewController(viewModel: diContainer.makeManageViewModel())
    }
    
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController {
        MyPageJoinDetailViewController(viewModel: diContainer.makeMyPageJoinViewModel())
    }
    
    func makePotDetailViewController(postId: Int) -> PotDetailViewController {
        PotDetailViewController(
            viewModel: diContainer.makePotDetailViewModel(postId: postId)
        )
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        OnboardingViewController(viewModel: OnboardingViewModel(), factory: self)
    }
    
    func makeValidNicknameViewController() -> ValidNicknameViewController {
        ValidNicknameViewController(viewModel: OnboardingViewModel(), factory: self)
    }
    
    func makeSelectFavoriteIdolGroupViewController() -> SelectFavoriteIdolGroupViewController {
        SelectFavoriteIdolGroupViewController(viewModel: OnboardingViewModel(), factory: self)
    }
}
