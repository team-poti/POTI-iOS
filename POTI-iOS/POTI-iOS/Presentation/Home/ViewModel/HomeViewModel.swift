//
//  HomeViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Combine

final class HomeViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case bannerScrolled(index: Int)
        case searchButtonTapped
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let updateBannerPage: AnyPublisher<Int, Never>
        let withdrawCompleted: AnyPublisher<Void, Never>
    }
    
    // MARK: - Subjects
    
    private let withdrawCompletedSubject = PassthroughSubject<Void, Never>()
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let bannerPageSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private let withDrawUseCase: WithdrawUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var isMyGroupMixed: Bool = false
    
    let output: Output
    
    private(set) var banners: [BannerModel] = []
    private(set) var myGroupItems: [GoodsModel] = []
    private(set) var otherGroupItems: [GoodsModel] = []
    private(set) var nickname: String = ""
    private(set) var mainArtistId: Int = 0
    
    // MARK: - Initializer
    
    init(
        useCase: HomeUseCase,
        withDrawUseCase: WithdrawUseCase
    ) {
        self.useCase = useCase
        self.withDrawUseCase = withDrawUseCase
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            updateBannerPage: bannerPageSubject.eraseToAnyPublisher(),
            withdrawCompleted: withdrawCompletedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchHomeData()
        case .bannerScrolled(let index):
            bannerPageSubject.send(index)
        case .searchButtonTapped:
            withdraw()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchHomeData() {
        Task {
            do {
                let data = try await useCase.execute()
                
                self.banners = data.toBannerModelList()
                self.myGroupItems = data.toMyGoodsModelList()
                self.otherGroupItems = data.toOtherGoodsModelList()
                self.nickname = data.nickname
                self.mainArtistId = data.mainArtistId ?? 0
                
                if !myGroupItems.isEmpty {
                    self.isMyGroupMixed = myGroupItems.contains { $0.artistId != self.mainArtistId }
                }
                
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
