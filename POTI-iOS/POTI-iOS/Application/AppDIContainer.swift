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
    
    private func makeImageUploadService() -> ImageUploadService {
        DefaultImageUploadService(networkService: makeNetworkService())
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
        DefaultOrderRepository(networkService: makeNetworkService())
    }
    
    private func makePostsRepository() -> PostsInterface {
        DefaultPostsRepository(networkService: makeNetworkService())
    }
    
    private func makePotDetailRepository() -> PotDetailInterface {
        DefaultPotDetailRepository(networkService: makeNetworkService())
    }
    
    private func makeManageRepository() -> PostsInterface {
        DefaultPostsRepository(networkService: makeNetworkService())
    }
    
    private func makePotListRepository() -> PotListInterface {
        DefaultPotListRepository(networkService: makeNetworkService())
    }
    
    private func makeArtistsRepository() -> ArtistsInterface {
        DefaultArtistsRepository(networkService: makeNetworkService())
    }
    
    private func makeUsersRepository() -> UsersInterface {
        DefaultUsersRepository(networkService: makeNetworkService())
    }
    
    private func makeImagesRepository() -> ImagesInterface {
        DefaultImagesRepository(imageUploadService: makeImageUploadService())
    }
    
    private func makePotsSaleRepository() -> PostsInterface {
        DefaultPostsRepository(networkService: makeNetworkService())
    }
    
    private func makeRegisterRepository() -> RegisterInterface {
        DefaultRegisterRepository(networkService: makeNetworkService())
    }
    
    private func makePaymentsRepository() -> PaymentsInterface {
        DefaultPaymentsRepository(networkService: makeNetworkService())
    }
    
    private func makeParticipationsRepository() -> ParticipationsInterface {
        DefaultParticipationsRepository(networkService: makeNetworkService())
    }
    
    private func makePostPaymentsRepository() -> PaymentsInterface {
        DefaultPaymentsRepository(networkService: makeNetworkService())
    }
    
    private func makeParticipationsDeliveredRepository() -> ParticipationsInterface {
        DefaultParticipationsRepository(networkService: makeNetworkService())
    }
    
    private func makeCreateReviewsRepository() -> ReviewsInterface {
        DefaultReviewsRepository(networkService: makeNetworkService())
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
    
    private func makeManageUseCase() -> PostsParticipantsUseCase {
        DefaultManageUseCase(repository: makeManageRepository())
    }
    
    private func makePotListUseCase() -> PotListUseCase {
        DefaultPotListUseCase(repository: makePotListRepository())
    }
    
    private func makeArtistsUseCase() -> ArtistsUsecase {
        DefaultArtistsUseCase(repository: makeArtistsRepository())
    }
    
    private func makeRegisterArtistsUseCase() -> RegisterArtistsUseCase {
        DefaultRegisterArtistsUseCase(repository: makeRegisterRepository())
    }
    
    private func makeRegisterTitlesUseCase() -> RegisterTitlesUseCase {
        DefaultRegisterTitlesUseCase(repository: makeRegisterRepository())
    }
    
    private func makeRegisterPostsUseCase() -> RegisterPostsUseCase {
        DefaultRegisterPostsUseCase(repository: makeRegisterRepository())
    }
    
    private func makePostsSaleUseCase() -> PostsSaleUseCase {
        DefaultPostsSaleUseCase(repository: makePostsRepository())
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
    
    private func makePaymentsUseCase() -> PaymentsConfirmUseCase {
        DefaultPaymentsUseCase(repository: makePaymentsRepository())
    }
    
    private func makeOrdersDeliveriesUseCase() -> OrdersDeliveriesUseCase {
        DefaultOrdersDeliveriesUseCase(repository: makeOrderRepository())
    }
    
    private func makeGetMyPageInformationUseCase() -> GetMyPageInformationUseCase {
        DefaultGetMyPageInformationUseCase(repository: makeUsersRepository())
    }
    
    private func makeMyPagePostsHistoryUseCase() -> MyPagePostsHistoryUseCase {
        DefaultMyPagePostsHistoryUseCase(repository: makePostsRepository())
    }
    
    private func makeMyPageParticipationsHistoryUseCase() -> MyPageParticipationsHistoryUseCase {
        DefaultMyPageParticipationsHistoryUseCase(repository: makeParticipationsRepository())
    }
    
    private func makeGetYourPageInformationUseCase() -> GetYourPageInformationUseCase {
        DefaultGetYourPageInformationUseCase(repository: makeUsersRepository())
    }
    
    private func makeParticipationsDetailUseCase() -> ParticipationsDetailUseCase {
        DefaultParticipationsDetailUseCase(repository: makeParticipationsRepository())
    }
    
    private func makePostPaymentsUseCase() -> PostPaymentsUseCase {
        DefaultPostPaymentsUseCase(repository: makePaymentsRepository())
    }
    
    private func makeParticipationsDeliveredUseCase() -> ParticipationsDeliveredUseCase {
        DefaultParticipationsDeliveredUseCase(repository: makeParticipationsDeliveredRepository())
    }
    
    private func makeCreateReviewUseCase() -> ReviewUseCase {
        DefaultReviewUseCase(repository: makeCreateReviewsRepository())
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
    
    func makePotOrderViewModel(postId: Int, shippingId: Int,orderItems: [OrderItem], shippingInfo: (name: String, price: Int), memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewModel {
        return PotOrderViewModel(useCase: makeSubmitUseCase(), postId: postId, shippingId: shippingId, orderItems: orderItems, shippingInfo: shippingInfo, memberInfos: memberInfos, uploaderNickname: uploaderNickname)
    }
    
    func makePotOptionsViewModel(postId: Int) -> PotOptionsViewModel {
        PotOptionsViewModel(useCase: makePotOptionUseCase(), postId: postId)
    }
    
    func makeRecruitDetailViewModel(postId: Int) -> RecruitDetailViewModel {
        RecruitDetailViewModel(postId: postId, postsSaleUseCase: makePostsSaleUseCase())
    }
    
    func makeManageViewModel(postId: Int) -> ParticipantManageViewModel {
        ParticipantManageViewModel(
            postId: postId,
            postsParticipantsUseCase: makeManageUseCase(),
            paymentsUseCase: makePaymentsUseCase(),
            ordersDeliveriesUseCase: makeOrdersDeliveriesUseCase()
        )
    }
    
    func makeMyPageJoinViewModel(participationId: Int, orderId: Int) -> MyPageJoinViewModel {
        MyPageJoinViewModel(
            participationId: participationId, orderId: orderId,
            participationsDetailUsecase: makeParticipationsDetailUseCase(),
            postPaymentsUseCase: makePostPaymentsUseCase(),
            participationsDeliveredUseCase: makeParticipationsDeliveredUseCase(),
            createReviewUseCase: makeCreateReviewUseCase()
        )
    }
    
    func makePotListViewModel(title: String, artistId: Int, artistName: String) -> PotListViewModel {
        return PotListViewModel(useCase: makePotListUseCase(),title: title,artistId: artistId, artistName: artistName)
    }
    
    func makeArtistsViewModel(artistId: Int, selectedIds: [Int]) -> ArtistsViewModel {
        return ArtistsViewModel(useCase: makeArtistsUseCase(), artistId: artistId, selectedIds: selectedIds)
    }
    
    func makeProductRegisterViewModel() -> ProductRegisterViewModel {
        ProductRegisterViewModel(
            registerTitlesUseCase: makeRegisterTitlesUseCase(),
            registerPostsUseCase: makeRegisterPostsUseCase(),
            imagesRepository: makeImagesRepository(),
            artistsUseCase: makeArtistsUseCase()
        )
    }
    
    func makeArtistSearchViewModel() -> ArtistSearchViewModel {
        ArtistSearchViewModel(registerArtistsUseCase: makeRegisterArtistsUseCase())
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(
            onboardingArtistsUsecase: makeOnboardingArtistsUsecase(),
            validNicknameUseCase: makeValidNicknameUseCase(),
            submitOnboardingUseCase: makeSubmitOnboardingUseCase()
        )
    }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        MyPageViewModel(getMyPageInformationUseCase: makeGetMyPageInformationUseCase())
    }
    
    func makeMyPageHistoryViewModel(
        initialType: MyPageHistoryType
    ) -> MyPageHistoryViewModel {
        MyPageHistoryViewModel(
            initialType: initialType,
            myPagePostsHistoryUseCase: makeMyPagePostsHistoryUseCase(),
            myPageParticipationsHistoryUseCase: makeMyPageParticipationsHistoryUseCase()
        )
    }
    
    func makeYourPageViewModel(userId: Int) -> YourPageViewModel {
        YourPageViewModel(
            userId: userId, getYourPageInformationUseCase: makeGetYourPageInformationUseCase()
        )
    }
}
