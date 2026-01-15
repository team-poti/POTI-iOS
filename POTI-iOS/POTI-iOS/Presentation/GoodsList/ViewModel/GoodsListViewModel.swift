//
//  GoodsListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Combine

final class GoodsListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: GoodsListUseCase
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var groupItems: [GroupItemModel] = []
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: GoodsListUseCase) {
        self.useCase = useCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchGoodsList()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchGoodsList() {
        Task {
            do {
                let data = try await useCase.execute()
                self.groupItems = data.toGroupItemModel()
                reloadDataSubject.send(())
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
