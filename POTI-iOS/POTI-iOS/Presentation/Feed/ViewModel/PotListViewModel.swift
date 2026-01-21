//
//  PotListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//


//
//  PotListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Combine

final class PotListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: PotListUseCase
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var pots: [FeedModel] = []
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: PotListUseCase) {
        self.useCase = useCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotListData()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchPotListData() {
        Task {
            do {
                let potEntities = try await useCase.execute()
                self.pots = potEntities.toFeedModel()
                reloadDataSubject.send(())
            } catch {
                print("Error fetching pots: \(error)")
            }
        }
    }
}
