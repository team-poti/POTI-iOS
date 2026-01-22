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
    func makeValidNicknameViewController() -> ValidNicknameViewController
    func makeSelectFavoriteIdolGroupViewController() -> SelectFavoriteIdolGroupViewController
    func makeRecruitDetailViewController() -> RecruitDetailViewController
    func makeParticipantManageViewController() -> ParticipantListTableViewController
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController
    func makePotListViewController(title: String, artistId: Int, artistName: String) -> PotListViewController
    func makeArtistsBottomSheet(artistId: Int) -> ArtistsBottomSheet
    func makeSortBottomSheet(initialIndex: Int) -> SortBottomSheet
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
        GoodsListViewController(viewModel: diContainer.makeGoodsListViewModel(sectionType: sectionType, artistId: artistId, nickname: nickname), factory: self)
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(
            viewModel: MyPageViewModel()
        )
    }
    
    func makePotOptionsSheetViewController(postId: Int) -> PotOptionsSheetViewController {
        PotOptionsSheetViewController(
            viewModel: diContainer.makePotOptionsSheetViewModel(postId: postId)
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
    
    func makePotListViewController(title: String, artistId: Int, artistName: String) -> PotListViewController {
        let viewModel = diContainer.makePotListViewModel(title: title, artistId: artistId, artistName: artistName)
        return PotListViewController(viewModel: viewModel, factory: self)
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
    
    func makeArtistsBottomSheet(artistId: Int) -> ArtistsBottomSheet {
        let viewModel = diContainer.makeArtistsViewModel(artistId: artistId)
        return ArtistsBottomSheet(viewModel: viewModel)
    }
    
    func makeSortBottomSheet(initialIndex: Int) -> SortBottomSheet {
        let viewModel = SortViewModel(initialIndex: initialIndex)
        return SortBottomSheet(viewModel: viewModel)
    }
}
