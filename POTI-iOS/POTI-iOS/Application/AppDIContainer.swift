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
        DefaultHomeRepository()
    }
    
    private func makeGoodsListRepository() -> GoodsListInterface {
        DefaultGoodsListRepository()
    }

    private func makeOrderRepository() -> OrderInterface {
        DefaultOrderRepository()
    }
    
    private func makePotDetailRepository() -> PotDetailInterface {
        DefaultPotDetailRepository()
    }
    
    private func makeManageRepository() -> PostsInterface {
        DefaultManageRepository()
    }
    
    private func makePotListRepository() -> PotListInterface {
        DefaultPotListRepository()
    }
    
    private func makeArtistsRepository() -> ArtistsInterface {
        DefaultArtistsRepository()
    }
    
    private func makeUsersRepository() -> UsersInterface {
        DefaultUsersRepository()
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

    private func makeOrderUseCase() -> OrderUseCase {
        DefaultOrderUseCase(repository: makeOrderRepository())
    }
    
    private func makePotDetailUseCase() -> PotDetailUseCase {
        DefaultPotDetailUseCase(repository: makePotDetailRepository())
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
    
    private func makeOnboardingArtistsUsecase() -> OnboardingArtistsUsecase {
        DefaultOnboardingArtistsUsecase(repository: makeArtistsRepository())
    }
    
    private func makeValidNicknameUseCase() -> ValidNicknameUseCase {
        DefaultValidNicknameUseCase(repository: makeUsersRepository())
    }
    
    private func makeSubmitOnboardingUseCase() -> SubmitOnboardingUseCase {
        DefaultSubmitOnboardingUseCase(repository: makeUsersRepository())
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
    
    func makeGoodsListViewModel() -> GoodsListViewModel {
        GoodsListViewModel(useCase: makeGoodsListUseCase())
    }
      
    func makeOrderViewModel() -> OrderViewModel {
        OrderViewModel(useCase: makeOrderUseCase())
    }
    
    func makePotDetailViewModel(postId: Int) -> PotDetailViewModel {
        PotDetailViewModel(useCase: makePotDetailUseCase(), postId: postId)
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
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(onboardingArtistsUsecase: makeOnboardingArtistsUsecase(), validNicknameUseCase: makeValidNicknameUseCase(), submitOnboardingUseCase: makeSubmitOnboardingUseCase())
    }
}
