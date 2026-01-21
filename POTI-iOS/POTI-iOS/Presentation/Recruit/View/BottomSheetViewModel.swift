//
//  BottomSheetViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/21/26.
//

import UIKit

import Combine

struct BottomSheetSubmitPayload: Equatable {
    let depositor: String
    let depositTime: String
}

class BottomSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case tapComplete(depositor: String, depositTime: String)
    }
    
    // MARK: - Output
    
    struct Output {
        let isCompleteEnabled: AnyPublisher<Bool, Never>
        let submit: AnyPublisher<BottomSheetSubmitPayload, Never>
    }
    
    let output: Output
    
    private var cancellables = Set<AnyCancellable>()
    
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let submitSubject = PassthroughSubject<BottomSheetSubmitPayload, Never>()
    
    // MARK: - Initializer
    
    init() {
        self.output = Output(
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            submit: submitSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .tapComplete(let depositor, let depositTime):
            submitSubject.send(.init(depositor: depositor, depositTime: depositTime))
        }
    }
}

