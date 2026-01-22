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
    func makeGoodsListViewController(sectionType: HomeSection, artistId: Int, nickname: String) -> GoodsListViewController
    func makePotOptionsSheetViewController(postId: Int) -> PotOptionsSheetViewController
    func makePotDetailViewController(postId: Int) -> PotDetailViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeOnboardingViewController() -> OnboardingViewController
    func makeValidNicknameViewController(viewModel: OnboardingViewModel) -> ValidNicknameViewController
    func makeSelectFavoriteIdolGroupViewController(viewModel: OnboardingViewModel) -> SelectFavoriteIdolGroupViewController
    func makeRecruitDetailViewController(postId: Int) -> RecruitDetailViewController
    func makeParticipantManageViewController() -> ParticipantListTableViewController
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController
    func makePotListViewController() -> PotListViewController
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
            viewModel: diContainer.makeHomeViewModel(),factory: self  
        )
    }
    
    func makeGoodsListViewController(sectionType: HomeSection, artistId: Int, nickname: String) -> GoodsListViewController {
        GoodsListViewController(viewModel: diContainer.makeGoodsListViewModel(sectionType: sectionType, artistId: artistId, nickname: nickname)
        )
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(
            viewModel: diContainer.makeMyPageViewModel()
        )
    }
    
    func makePotOptionsSheetViewController(postId: Int) -> PotOptionsSheetViewController {
        PotOptionsSheetViewController(
            viewModel: diContainer.makePotOptionsSheetViewModel(postId: postId)
        )
    }
    
    func makeRecruitDetailViewController(postId: Int) -> RecruitDetailViewController {
        RecruitDetailViewController(viewModel: diContainer.makeRecruitDetailViewModel(postId: postId))
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
        OnboardingViewController(
            viewModel: diContainer.makeOnboardingViewModel(), factory: self
        )
    }
    
    func makeValidNicknameViewController(viewModel: OnboardingViewModel) -> ValidNicknameViewController {
        ValidNicknameViewController(viewModel: viewModel, factory: self)
    }
    
    func makeSelectFavoriteIdolGroupViewController(viewModel: OnboardingViewModel) -> SelectFavoriteIdolGroupViewController {
        SelectFavoriteIdolGroupViewController(viewModel: viewModel, factory: self)
    }
    
    func makePotListViewController() -> PotListViewController {
        PotListViewController(
            viewModel: diContainer.makePotListViewModel()
        )
    }
    
    func makePotOrderViewController(postId: Int, shippingId: Int, orderItems: [OrderOptionItem]) -> PotOrderViewController {
        return PotOrderViewController(
            viewModel: diContainer.makePotOrderViewModel(
                postId: postId,
                shippingId: shippingId,
                orderItems: orderItems
            ),
            factory: self
        )
    }
}
