//
//  OnboardingViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController<OnboardingViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = OnboardingDescriptionView()
    private let factory: ViewControllerFactory
    
    init(viewModel: OnboardingViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
}

extension OnboardingViewController {
    @objc private func nextButtonDidTap() {
        let validNicknameVC = factory.makeValidNicknameViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(validNicknameVC, animated: true)
    }
}
