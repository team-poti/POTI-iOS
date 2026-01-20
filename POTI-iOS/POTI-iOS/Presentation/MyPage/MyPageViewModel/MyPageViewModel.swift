//
//  MyPageViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import Combine

final class MyPageViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let isLoading: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    public let output: Output
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Initializer
    
    init() {
        self.output = Output(
            isLoading: isLoadingSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    public func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: 초기 데이터 로드
            break
        }
    }
}
