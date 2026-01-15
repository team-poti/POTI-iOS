//
//  GoodsListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Foundation

import Combine

final class GoodsListViewModel: BaseViewModelType {
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    //MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: GoodsListUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var groupItems: [GroupItem] = []
    
    init(useCase: GoodsListUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let reloadData = PassthroughSubject<Void, Never>()
        
        input.viewDidLoad
            .sink { [weak self] in
                Task {
                    do {
                        guard let data = try await self?.useCase.execute() else { return }
                        
                        self?.groupItems = data.groupItems
                        
                        reloadData.send(())
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
        
        return Output(
            reloadData: reloadData.eraseToAnyPublisher()
        )
    }
}
