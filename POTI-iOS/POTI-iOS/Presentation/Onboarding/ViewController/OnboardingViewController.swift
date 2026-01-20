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
    
    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
}

extension OnboardingViewController {
    @objc private func nextButtonDidTap() {
        // TODO: - 추후 이동 로직 뷰모델 안에 넣기
        let validNicknameViewController = ValidNicknameViewController()
        self.navigationController?.pushViewController(validNicknameViewController, animated: true)
    }
}
