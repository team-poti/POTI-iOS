//
//  ViewControllerFactory.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

@MainActor
protocol ViewControllerFactory {
    func makeLaunchScreenViewController() -> LaunchScreenViewController
    @MainActor func makeLoginViewController() -> LoginViewController
    func makePotiTabBar() -> PotiTabBar
    func makePushNotificationPermissionCoordinator() -> PushNotificationPermissionCoordinator
    func makeHomeViewController() -> HomeViewController
    func makeNotificationViewController() -> NotificationViewController
    func makeNotificationSettingViewController() -> NotificationSettingViewController
    func makeSearchViewController() -> SearchViewController
    func makeFeedsViewController(sectionType: HomeSection, artistId: Int?, nickname: String) -> FeedsViewController
    func makePotOptionsViewController(postId: Int) -> PotOptionsViewController
    func makePotDetailViewController(postId: Int) -> PotDetailViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeMyPageFavoriteIdolGroupViewController(nickname: String) -> MyPageFavoriteIdolGroupViewController
    func makeOnboardingViewController() -> OnboardingViewController
    func makeValidNicknameViewController(viewModel: OnboardingViewModel) -> ValidNicknameViewController
    func makeSelectFavoriteIdolGroupViewController(viewModel: OnboardingViewModel) -> SelectFavoriteIdolGroupViewController
    func makeRecruitDetailViewController(postId: Int) -> RecruitDetailViewController
    func makeParticipantManageViewController(postId: Int) -> ParticipantListTableViewController
    func makeMyPageHistoryContainerViewController(
        initialType: MyPageHistoryType,
        initialTab: MyPageHistoryViewController.HistoryTab,
        entryPoint: MyPageHistoryEntryPoint
    ) -> MyPageHistoryContainerViewController
    func makePotListViewController(title: String, artistId: Int, artistName: String) -> PotListViewController
    func makeArtistSearchViewController() -> ArtistSearchViewController
    func makeProductRegisterViewController() -> RegisterViewController
    func makeArtistMembersFilterBottomSheet(artistId: Int, selectedIds: [Int]) -> ArtistMembersFilterBottomSheet
    func makeSortBottomSheet(type: SortType, initialIndex: Int) -> SortBottomSheet
    func makeMyPageJoinDetailViewController(participationId: Int) -> MyPageJoinDetailViewController
    func makePotOrderViewController(postId: Int, shippingId: Int, orderItems: [ParticipationItem], shippingInfo: (name: String, price: Int),memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewController
    func makeYourPageViewController(userId: Int) -> YourPageViewController
    @MainActor func makeSettingsViewController() -> SettingsViewController
    @MainActor func makeAccountViewController(viewModel: SettingsViewModel) -> AccountViewController
    @MainActor func makeProfileManagementViewController(viewModel: SettingsViewModel) -> ProfileManagementViewController
    @MainActor func makeAddressManagementViewController(viewModel: SettingsViewModel) -> AddressManagementViewController
    @MainActor func makePostcodeSearchViewController(
        onSelect: @escaping (String, String) -> Void
    ) -> PostcodeSearchViewController
    @MainActor func makeWithdrawalViewController(viewModel: SettingsViewModel) -> WithdrawalViewController
    func makeReviewUseCase() -> ReviewUseCase
}

@MainActor
final class DefaultViewControllerFactory: ViewControllerFactory {
    private let diContainer: AppDIContainer
    private let pushNotificationPermissionService: PushNotificationPermissionService = DefaultPushNotificationPermissionService()
    private lazy var notificationSettingViewModel = diContainer.makeNotificationSettingViewModel()
    private lazy var pushNotificationPermissionCoordinator = PushNotificationPermissionCoordinator(viewModel: notificationSettingViewModel,
                                                                                                    permissionService: pushNotificationPermissionService)
    
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

    func makePushNotificationPermissionCoordinator() -> PushNotificationPermissionCoordinator {
        pushNotificationPermissionCoordinator
    }
    
    @MainActor func makeHomeViewController() -> HomeViewController {
        HomeViewController(
            viewModel: diContainer.makeHomeViewModel(),factory: self
        )
    }

    func makeNotificationViewController() -> NotificationViewController {
        NotificationViewController(viewModel: diContainer.makeNotificationViewModel(), factory: self)
    }

    func makeNotificationSettingViewController() -> NotificationSettingViewController {
        NotificationSettingViewController(viewModel: notificationSettingViewModel,
                                          pushNotificationPermissionCoordinator: makePushNotificationPermissionCoordinator())
    }

    func makeSearchViewController() -> SearchViewController {
        SearchViewController(viewModel: diContainer.makeSearchViewModel(), factory: self)
    }
    
    func makeFeedsViewController(sectionType: HomeSection, artistId: Int?, nickname: String) -> FeedsViewController {
        FeedsViewController(viewModel: diContainer.makeFeedsViewModel(sectionType: sectionType, artistId: artistId, nickname: nickname), factory: self)
    }
    
    func makeArtistMembersFilterBottomSheet(artistId: Int, selectedIds: [Int]) -> ArtistMembersFilterBottomSheet {
        let viewModel = diContainer.makeArtistMembersFilterViewModel(artistId: artistId, selectedIds: selectedIds)
        return ArtistMembersFilterBottomSheet(viewModel: viewModel)
    }
    
    func makeSortBottomSheet(type: SortType, initialIndex: Int) -> SortBottomSheet {
        let viewModel = SortViewModel(type: type, initialIndex: initialIndex)
        return SortBottomSheet(viewModel: viewModel)
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(
            viewModel: diContainer.makeMyPageViewModel(), factory: self
        )
    }

    func makeMyPageFavoriteIdolGroupViewController(nickname: String) -> MyPageFavoriteIdolGroupViewController {
        MyPageFavoriteIdolGroupViewController(
            nickname: nickname,
            viewModel: diContainer.makeOnboardingViewModel()
        )
    }
    
    func makePotOptionsViewController(postId: Int) -> PotOptionsViewController {
        PotOptionsViewController(viewModel: diContainer.makePotOptionsViewModel(postId: postId))
    }
    
    func makeRecruitDetailViewController(postId: Int) -> RecruitDetailViewController {
        RecruitDetailViewController(
            viewModel: diContainer.makeRecruitDetailViewModel(postId: postId),
            factory: self
        )
    }
    
    func makeParticipantManageViewController(postId: Int) -> ParticipantListTableViewController {
        ParticipantListTableViewController(viewModel: diContainer.makeManageViewModel(postId: postId))
    }
    
    func makeMyPageJoinDetailViewController(participationId : Int) -> MyPageJoinDetailViewController {
        MyPageJoinDetailViewController(viewModel: diContainer.makeMyPageJoinViewModel(participationId: participationId), factory: self)
    }
    
    func makePotDetailViewController(postId: Int) -> PotDetailViewController {
        PotDetailViewController(viewModel: diContainer.makePotDetailViewModel(postId: postId), factory: self)
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
    
    func makePotOrderViewController(postId: Int, shippingId: Int, orderItems: [ParticipationItem], shippingInfo: (name: String, price: Int),memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewController {
        return PotOrderViewController(viewModel: diContainer.makePotOrderViewModel(postId: postId, shippingId: shippingId,orderItems: orderItems, shippingInfo: shippingInfo,memberInfos: memberInfos, uploaderNickname: uploaderNickname), factory: self
        )
    }
    
    func makeMyPageHistoryContainerViewController(
        initialType: MyPageHistoryType,
        initialTab: MyPageHistoryViewController.HistoryTab = .ongoing,
        entryPoint: MyPageHistoryEntryPoint
    ) -> MyPageHistoryContainerViewController {
        MyPageHistoryContainerViewController(
            initialType: initialType,
            initialTab: initialTab,
            entryPoint: entryPoint,
            viewModel: diContainer.makeMyPageHistoryViewModel(initialType: initialType),
            factory: self
        )
    }
    
    func makeArtistSearchViewController() -> ArtistSearchViewController {
        ArtistSearchViewController(viewModel: diContainer.makeArtistSearchViewModel())
    }
    
    func makeProductRegisterViewController() -> RegisterViewController {
        RegisterViewController(viewModel: diContainer.makeProductRegisterViewModel(), factory: self)
    }
    
    func makeYourPageViewController(userId: Int) -> YourPageViewController {
        YourPageViewController(viewModel: diContainer.makeYourPageViewModel(userId: userId))
    }

    @MainActor func makeSettingsViewController() -> SettingsViewController {
        SettingsViewController(
            viewModel: diContainer.makeSettingsViewModel(),
            factory: self
        )
    }

    @MainActor func makeAccountViewController(viewModel: SettingsViewModel) -> AccountViewController {
        AccountViewController(viewModel: viewModel, factory: self)
    }

    @MainActor func makeProfileManagementViewController(
        viewModel: SettingsViewModel
    ) -> ProfileManagementViewController {
        ProfileManagementViewController(viewModel: viewModel)
    }

    @MainActor func makeAddressManagementViewController(
        viewModel: SettingsViewModel
    ) -> AddressManagementViewController {
        AddressManagementViewController(viewModel: viewModel, factory: self)
    }

    @MainActor func makePostcodeSearchViewController(
        onSelect: @escaping (String, String) -> Void
    ) -> PostcodeSearchViewController {
        PostcodeSearchViewController(onSelect: onSelect)
    }

    @MainActor func makeWithdrawalViewController(
        viewModel: SettingsViewModel
    ) -> WithdrawalViewController {
        WithdrawalViewController(viewModel: viewModel, factory: self)
    }
    
    func makeReviewUseCase() -> ReviewUseCase {
        diContainer.makeCreateReviewUseCase()
    }
}
