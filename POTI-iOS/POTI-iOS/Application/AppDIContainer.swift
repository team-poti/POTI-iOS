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
    
    private func makeTokenRefreshNetworkService() -> NetworkService {
        NetworkService()
    }
    
    private func makeNetworkService() -> NetworkService {
        NetworkService(interceptor: makeAuthInterceptor())
    }
    
    private func makeTokenRefreshService() -> TokenRefreshService {
        DefaultTokenRefreshService(
            networkService: makeTokenRefreshNetworkService()
        )
    }
    
    private func makeAuthInterceptor() -> AuthInterceptor {
        AuthInterceptor(
            tokenRefreshService: makeTokenRefreshService()
        )
    }
    
    // MARK: - Repository
    
    @MainActor private func makeAuthRepository() -> AuthInterface {
        DefaultAuthRepository(authService: makeAuthService(), networkService: makeNetworkService(), tokenRefreshNetworkService: makeTokenRefreshNetworkService())
    }
    
    private func makeHomeRepository() -> HomeInterface {
        DefaultHomeRepository(networkService: makeNetworkService())
    }
    
    private func makeGoodsListRepository() -> GoodsListInterface {
        DefaultGoodsListRepository(networkService: makeNetworkService())
    }
    
    private func makeOrderRepository() -> OrderInterface {
        DefaultOrderRepository()
    }
    
    private func makePostsRepository() -> PostsInterface {
        DefaultPostsRepository()
    }
    
    private func makePotDetailRepository() -> PotDetailInterface {
        DefaultPotDetailRepository()
    }
    
    private func makeManageRepository() -> PostsInterface {
        DefaultPostsRepository()
    }
    
    private func makePotListRepository() -> PotListInterface {
        DefaultPotListRepository()
    }
    
    private func makeArtistsRepository() -> ArtistsInterface {
        DefaultArtistsRepository()
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
    
    @MainActor private func makeRefreshTokenUseCase() -> RefreshTokenUseCase {
        DefaultRefreshTokenUseCase(
            repository: makeAuthRepository()
        )
    }
    
    private func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(repository: makeHomeRepository())
    }
    
    private func makeGoodsListUseCase() -> GoodsListUseCase {
        DefaultGoodsListUseCase(repository: makeGoodsListRepository())
    }
    
    private func makeOrderUseCase() -> SubmitOrderUseCase {
        DefaultSubmitOrderUseCase(repository: makeOrderRepository())
    }
    
    private func makePotDetailUseCase() -> PotDetailUseCase {
        DefaultPotDetailUseCase(repository: makePotDetailRepository())
    }
    
    private func makeSubmitUseCase() -> SubmitOrderUseCase {
        DefaultSubmitOrderUseCase(repository: makeOrderRepository())
    }
    
    private func makePotOptionUseCase() -> PotOptionsUseCase {
        DefaultPotOptionsUseCase(repository: makePostsRepository())
    }
    
    private func makeManageUseCase() -> PostsUseCase {
        DefaultManageUseCase(repository: makeManageRepository())
    }
    
    private func makePotListUseCase() -> PotListUseCase {
        DefaultPotListUseCase(repository: makePotListRepository())
    }
    
    private func makeArtistsUseCase() -> ArtistsUsecase {
        DefaultArtistsUseCase(repository: makeArtistsRepository())
    }
    
    // MARK: - ViewModel
    
    @MainActor func makeLaunchScreenViewModel() -> LaunchScreenViewModel {
        LaunchScreenViewModel(refreshTokenUseCase: makeRefreshTokenUseCase())
    }
    
    @MainActor func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase(), devLoginUseCase: makeDevLoginUseCase())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeHomeUseCase())
    }
    
    func makeGoodsListViewModel(sectionType: HomeSection, artistId: Int, nickname: String) -> GoodsListViewModel {
        GoodsListViewModel(useCase: makeGoodsListUseCase(),sectionType: sectionType,artistId: artistId,nickname: nickname)
    }
    
    func makePotDetailViewModel(postId: Int) -> PotDetailViewModel {
        PotDetailViewModel(useCase: makePotDetailUseCase(), postId: postId)
    }
    
    func makePotOrderViewModel(postId: Int, shippingId: Int, orderItems: [OrderOptionItem]) -> PotOrderViewModel {
        PotOrderViewModel(useCase: makeSubmitUseCase(), postId: postId, shippingId: shippingId, orderItems: orderItems)
    }
    
    func makePotOptionsSheetViewModel(postId: Int) -> PotOptionsViewModel {
        PotOptionsViewModel(useCase: makePotOptionUseCase(), postId: postId)
    }
    
    func makeOrderViewModel(postId: Int) -> PotOptionsViewModel {
        PotOptionsViewModel(useCase: makePotOptionUseCase(), postId: postId)
    }
    
    func makeRecruitDetailViewModel() -> RecruitDetailViewModel {
        RecruitDetailViewModel()
    }
    
    func makeManageViewModel() -> ParticipantManageViewModel {
        ParticipantManageViewModel(useCase: makeManageUseCase())
    }
    
    func makeMyPageJoinViewModel() -> MyPageJoinViewModel {
        MyPageJoinViewModel()
    }
    
    func makePotListViewModel() -> PotListViewModel {
        PotListViewModel(useCase: makePotListUseCase())
    }
    
    func makeArtistsViewModel() -> ArtistsViewModel {
        ArtistsViewModel(useCase: makeArtistsUseCase())
    }
}
