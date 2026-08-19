//
//  HomeViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/14/26.
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
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Subjects
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let output: Output
    
    private(set) var banners: [BannerModel] = []
    private(set) var myGroupItems: [GoodsModel] = []
    private(set) var otherGroupItems: [GoodsModel] = []
    private(set) var nickname: String = ""
    private(set) var mainArtistId: Int? = nil
    private(set) var userStatus: HomeUserStatus = .noFavoriteArtist
    
    // MARK: - Initializer
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
        self.output = Output(reloadData: reloadDataSubject.eraseToAnyPublisher())
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchHomeData()
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
    
}
