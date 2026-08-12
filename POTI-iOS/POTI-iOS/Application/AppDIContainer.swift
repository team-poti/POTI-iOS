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

    private func makePostRepository() -> PostInterface {
        MockPostRepository()
    }

    private func makeArtistsRepository() -> ArtistsInterface {
        MockArtistRepository()
    }

    private func makeParticipationRepository() -> ParticipationInterface {
        DefaultParticipationRepository(networkService: makeNetworkService())
    }

    private func makeOrderManagementRepository() -> OrderManagementInterface {
        DefaultOrderManagementRepository(networkService: makeNetworkService())
    }

    private func makeUsersRepository() -> UsersInterface {
        DefaultUsersRepository(networkService: makeNetworkService())
    }

    private func makeImagesRepository() -> ImagesInterface {
        DefaultImagesRepository(imageUploadService: makeImageUploadService())
    }

    private func makeRegisterRepository() -> RegisterInterface {
        MockRegisterRepository()
    }

    private func makePaymentsRepository() -> PaymentsInterface {
        DefaultPaymentsRepository(networkService: makeNetworkService())
    }

    private func makePostPaymentsRepository() -> PaymentsInterface {
        DefaultPaymentsRepository(networkService: makeNetworkService())
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
        DefaultHomeUseCase(repository: makePostRepository())
    }

    private func makeFeedsUseCase() -> FeedsUseCase {
        DefaultFeedsUseCase(repository: makePostRepository())
    }

    private func makePotListUseCase() -> PotListUseCase {
        DefaultPotListUseCase(repository: makePostRepository())
    }

    private func makePotDetailUseCase() -> PotDetailUseCase {
        DefaultPotDetailUseCase(repository: makePostRepository())
    }

    private func makePotOptionUseCase() -> FetchPotOptionsUseCase {
        DefaultFetchPotOptionsUseCase(repository: makePostRepository())
    }

    private func makeApplyParticipationUseCase() -> ApplyParticipationUseCase {
        DefaultApplyParticipationUseCase(repository: makeParticipationRepository())
    }

    private func makeArtistMembersUseCase() -> ArtistMembersUseCase {
        DefaultArtistMembersUseCase(repository: makeArtistsRepository())
    }

    private func makeArtistSearchUseCase() -> ArtistSearchUseCase {
        DefaultArtistSearchUseCase(repository: makeRegisterRepository())
    }

    private func makeFetchProductTitlesUseCase() -> FetchProductTitlesUseCase {
        DefaultFetchProductTitlesUseCase(repository: makeRegisterRepository())
    }

    private func makeRegisterPostUseCase() -> RegisterPostUseCase {
        DefaultRegisterPostUseCase(repository: makeRegisterRepository())
    }

    private func makePostsSaleUseCase() -> PostsSaleUseCase {
        DefaultPostsSaleUseCase(repository:  makeOrderManagementRepository())
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
        DefaultOrdersDeliveriesUseCase(repository: makeOrderManagementRepository())
    }

    private func makeGetMyPageInformationUseCase() -> GetMyPageInformationUseCase {
        DefaultGetMyPageInformationUseCase(repository: makeUsersRepository())
    }

    private func makeMyPagePostsHistoryUseCase() -> MyPagePostsHistoryUseCase {
        DefaultMyPagePostsHistoryUseCase(repository: makeUsersRepository())
    }

    private func makeMyPageParticipationsHistoryUseCase() -> MyPageParticipationsHistoryUseCase {
        DefaultMyPageParticipationsHistoryUseCase(repository: makeUsersRepository())
    }

    private func makeGetYourPageInformationUseCase() -> GetYourPageInformationUseCase {
        DefaultGetYourPageInformationUseCase(repository: makeUsersRepository())
    }

    private func makeParticipationDetailUseCase() -> ParticipationDetailUseCase {
        DefaultParticipationDetailUseCase(repository: makeParticipationRepository())
    }

    private func makePostPaymentsUseCase() -> PostPaymentsUseCase {
        DefaultPostPaymentsUseCase(repository: makePaymentsRepository())
    }

    private func makePostsParticipantsUseCase() -> PostsParticipantsUseCase {
        DefaultPostsParticipantsUseCase(repository: makeOrderManagementRepository())
    }

    private func makeParticipationDeliveredUseCase() -> ParticipationDeliveredUseCase {
        DefaultParticipationDeliveredUseCase(repository: makeParticipationRepository())
    }

    func makeCreateReviewUseCase() -> ReviewUseCase {
        DefaultReviewUseCase(repository: makeCreateReviewsRepository())
    }

    @MainActor private func makeWithdrawUseCase() -> WithdrawUseCase {
        DefaultWithdrawUseCase(repository: makeAuthRepository())
    }

    // MARK: - ViewModel

    @MainActor func makeLaunchScreenViewModel() -> LaunchScreenViewModel {
        LaunchScreenViewModel(refreshTokenUseCase: makeRefreshTokenUseCase())
    }

    @MainActor func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase(), devLoginUseCase: makeDevLoginUseCase())
    }

    @MainActor func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeHomeUseCase(), withDrawUseCase: makeWithdrawUseCase())
    }

    func makeFeedsViewModel(sectionType: HomeSection, artistId: Int?, nickname: String) -> FeedsViewModel {
        FeedsViewModel(useCase: makeFeedsUseCase(), sectionType: sectionType, artistId: artistId, nickname: nickname)
    }

    func makePotDetailViewModel(postId: Int) -> PotDetailViewModel {
        PotDetailViewModel(useCase: makePotDetailUseCase(), postId: postId)
    }

    func makePotOrderViewModel(postId: Int, shippingId: Int,orderItems: [ParticipationItem], shippingInfo: (name: String, price: Int), memberInfos: [(name: String, price: Int)], uploaderNickname: String) -> PotOrderViewModel {
        return PotOrderViewModel(useCase: makeApplyParticipationUseCase(), postId: postId, shippingId: shippingId, orderItems: orderItems, shippingInfo: shippingInfo, memberInfos: memberInfos, uploaderNickname: uploaderNickname)
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
            postsParticipantsUseCase: makePostsParticipantsUseCase(),
            paymentsUseCase: makePaymentsUseCase(),
            ordersDeliveriesUseCase: makeOrdersDeliveriesUseCase()
        )
    }

    func makeMyPageJoinViewModel(participationId: Int,) -> MyPageJoinViewModel {
        MyPageJoinViewModel(
            participationId: participationId,
            participationsDetailUsecase: makeParticipationDetailUseCase(),
            postPaymentsUseCase: makePostPaymentsUseCase(),
            participationsDeliveredUseCase: makeParticipationDeliveredUseCase(),
            createReviewUseCase: makeCreateReviewUseCase()
        )
    }

    func makePotListViewModel(title: String, artistId: Int, artistName: String) -> PotListViewModel {
        return PotListViewModel(useCase: makePotListUseCase(),title: title,artistId: artistId, artistName: artistName)
    }

    func makeArtistMembersFilterViewModel(artistId: Int, selectedIds: [Int]) -> ArtistMembersFilterViewModel {
        return ArtistMembersFilterViewModel(useCase: makeArtistMembersUseCase(), artistId: artistId, selectedIds: selectedIds)
    }

    func makeProductRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(fetchProductTitlesUseCase: makeFetchProductTitlesUseCase(), registerPostUseCase: makeRegisterPostUseCase(),
                          imagesRepository: makeImagesRepository(), artistMembersUseCase: makeArtistMembersUseCase())
    }

    func makeArtistSearchViewModel() -> ArtistSearchViewModel {
        ArtistSearchViewModel(artistSearchUseCase: makeArtistSearchUseCase())
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
