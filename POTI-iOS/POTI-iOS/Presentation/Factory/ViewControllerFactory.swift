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
    func makeParticipantManageViewController(postId: Int) -> ParticipantListTableViewController
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController
    func makePotListViewController(title: String, artistId: Int, artistName: String) -> PotListViewController
    func makeArtistsBottomSheet(artistId: Int, selectedIds: [Int]) -> ArtistsBottomSheet
    func makeSortBottomSheet(type: SortType, initialIndex: Int) -> SortBottomSheet
    func makePotOrderViewController(postId: Int, shippingId: Int, orderItems: [OrderItem], shippingInfo: (name: String, price: Int),memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewController
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
            viewModel: diContainer.makeMyPageViewModel()
        )
    }
    
    func makePotOptionsSheetViewController(postId: Int) -> PotOptionsSheetViewController {
        PotOptionsSheetViewController(
            viewModel: diContainer.makePotOptionsViewModel(postId: postId)
        )
    }
    
    func makeRecruitDetailViewController(postId: Int) -> RecruitDetailViewController {
        RecruitDetailViewController(viewModel: diContainer.makeRecruitDetailViewModel(postId: postId))
    }
    
    func makeParticipantManageViewController(postId: Int) -> ParticipantListTableViewController {
        ParticipantListTableViewController(viewModel: diContainer.makeManageViewModel(postId: postId))
    }
    
    func makeMyPageJoinDetailViewController() -> MyPageJoinDetailViewController {
        MyPageJoinDetailViewController(viewModel: diContainer.makeMyPageJoinViewModel())
    }
    
    func makePotDetailViewController(postId: Int) -> PotDetailViewController {
        PotDetailViewController(
            viewModel: diContainer.makePotDetailViewModel(postId: postId), factory: self
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
    
    func makePotListViewController(title: String, artistId: Int, artistName: String) -> PotListViewController {
        let viewModel = diContainer.makePotListViewModel(title: title, artistId: artistId, artistName: artistName)
        return PotListViewController(viewModel: viewModel, factory: self)
    }
    
    func makePotOrderViewController(postId: Int, shippingId: Int, orderItems: [OrderItem], shippingInfo: (name: String, price: Int),memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewController {
        return PotOrderViewController(viewModel: diContainer.makePotOrderViewModel(postId: postId, shippingId: shippingId,orderItems: orderItems, shippingInfo: shippingInfo,memberInfos: memberInfos, uploaderNickname: uploaderNickname), factory: self
        )
    }
    
    func makeArtistsBottomSheet(artistId: Int, selectedIds: [Int]) -> ArtistsBottomSheet {
        let viewModel = diContainer.makeArtistsViewModel(artistId: artistId, selectedIds: selectedIds)
        return ArtistsBottomSheet(viewModel: viewModel)
    }
    
    func makeSortBottomSheet(type: SortType, initialIndex: Int) -> SortBottomSheet {
        let viewModel = SortViewModel(type: type, initialIndex: initialIndex)
        return SortBottomSheet(viewModel: viewModel)
    }
}
