//
//  HomeViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Combine

enum HomeUserStatus {
    case favoriteArtistExist
    case favoriteArtistNoArticles
    case noFavoriteArtist
}

final class HomeViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case searchButtonTapped
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let withdrawCompleted: AnyPublisher<Void, Never>
    }
    
    // MARK: - Subjects
    
    private let withdrawCompletedSubject = PassthroughSubject<Void, Never>()
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private let withDrawUseCase: WithdrawUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let output: Output
    
    private(set) var banners: [BannerModel] = []
    private(set) var myGroupItems: [GoodsModel] = []
    private(set) var otherGroupItems: [GoodsModel] = []
    private(set) var nickname: String = ""
    private(set) var mainArtistId: Int? = nil
    private(set) var userStatus: HomeUserStatus = .noFavoriteArtist
    
    // MARK: - Initializer
    
    init(
        useCase: HomeUseCase,
        withDrawUseCase: WithdrawUseCase
    ) {
        self.useCase = useCase
        self.withDrawUseCase = withDrawUseCase
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            withdrawCompleted: withdrawCompletedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchHomeData()
        case .searchButtonTapped:
            // TODO: - 검색 View로 이동으로 변경하기
            withdraw()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchHomeData() {
        Task {
            do {
                let data = try await useCase.execute()
                
                self.banners = data.toBannerModels()
                self.myGroupItems = data.toMyGoodsModels()
                self.otherGroupItems = data.toOtherGoodsModels()
                self.nickname = data.nickname
                self.mainArtistId = data.mainArtistId
                
                guard let mainArtistId = self.mainArtistId else {
                    self.userStatus = .noFavoriteArtist
                    reloadDataSubject.send(())
                    return
                }
                
                let hasFavoriteArticles = myGroupItems.contains { $0.artistId == mainArtistId }
                self.userStatus = hasFavoriteArticles ? .favoriteArtistExist : .favoriteArtistNoArticles
                
                reloadDataSubject.send(())
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func withdraw() {
        Task {
            do {
                try await withDrawUseCase.execute()
                
                await MainActor.run {
                    KeychainManager.deleteAllTokens()
                    withdrawCompletedSubject.send(())
                }
            } catch {
                print("탈퇴 실패: \(error)")
            }
        }
    }
}
