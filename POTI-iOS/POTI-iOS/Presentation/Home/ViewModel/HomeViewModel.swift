//
//  HomeViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Foundation

import Combine

final class HomeViewModel: BaseViewModelType {
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let bannerScrolled: AnyPublisher<Int, Never>
    }
    
    //MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let updateBannerPage: AnyPublisher<Int, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var banners: [BannerItem] = []
    private(set) var myGroupItems: [GoodsItem] = []
    private(set) var otherGroupItems: [GoodsItem] = []
    private(set) var nickname: String = ""
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let reloadData = PassthroughSubject<Void, Never>()
        
        input.viewDidLoad
            .sink { [weak self] in
                Task {
                    do {
                        guard let data = try await self?.useCase.execute() else { return }
                        
                        self?.banners = data.banners
                        self?.myGroupItems = data.myGroupItems
                        self?.otherGroupItems = data.otherGroupItems
                        self?.nickname = data.nickname
                        
                        reloadData.send(())
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
        
        return Output(
            reloadData: reloadData.eraseToAnyPublisher(),
            updateBannerPage: input.bannerScrolled.eraseToAnyPublisher()
        )
    }
}
