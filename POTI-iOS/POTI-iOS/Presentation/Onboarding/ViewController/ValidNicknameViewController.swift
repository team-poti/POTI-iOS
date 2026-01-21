//
//  ValidNicknameViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ValidNicknameViewController: BaseViewController<OnboardingViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = ValidNicknameView()
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

extension ValidNicknameViewController {
    @objc private func nextButtonDidTap() {
        let selectFavoriteIdolGroupVC = factory.makeSelectFavoriteIdolGroupViewController()
        self.navigationController?.pushViewController(selectFavoriteIdolGroupVC, animated: true)
    }
}
