//
//  OnboardingViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/21/26.
//

import Combine

final class OnboardingViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case startButtonTap
        case skipButtonTap
    }
    
    // MARK: - Output
    
    struct Output {
        let didFinishOnboarding: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let didFinishOnboardingSubject = PassthroughSubject<Void, Never>()
    
    var output: Output {
        Output(
            didFinishOnboarding: didFinishOnboardingSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .startButtonTap:
            // TODO: 온보딩 완료 처리 (UserDefaults, 서버 호출 등)
            didFinishOnboardingSubject.send(())
            
        case .skipButtonTap:
            // TODO: 스킵 처리
            didFinishOnboardingSubject.send(())
        }
    }
}

