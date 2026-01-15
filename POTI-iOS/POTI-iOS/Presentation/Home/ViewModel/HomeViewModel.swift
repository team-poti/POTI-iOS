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
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let updateBannerPage: AnyPublisher<Int, Never>
    }
    
    // MARK: - Subjects
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let bannerPageSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let output: Output
    
    private(set) var banners: [BannerItem] = []
    private(set) var myGroupItems: [GoodsItem] = []
    private(set) var otherGroupItems: [GoodsItem] = []
    private(set) var nickname: String = ""
    
    // MARK: - Initializer
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            updateBannerPage: bannerPageSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchHomeData()
        case .bannerScrolled(let index):
            bannerPageSubject.send(index)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchHomeData() {
        Task {
            do {
                let data = try await useCase.execute()
                
                self.banners = data.banners
                self.myGroupItems = data.myGroupItems
                self.otherGroupItems = data.otherGroupItems
                self.nickname = data.nickname
                
                reloadDataSubject.send(())
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
