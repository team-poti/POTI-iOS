//
//  LoginViewController.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    private let rootView = LoginView()

    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        
        rootView.appleLoginButton.addTarget(self, action: #selector(devLoginButtonTapped), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        bindLoginSuccess()
        bindLoginFailure()
    }
}

extension LoginViewController {
    @objc private func kakaoLoginButtonTapped() {
        viewModel.action(.kakaoLoginTap)
    }
    
    @objc private func devLoginButtonTapped() {
        viewModel.action(.devLoginTap)
    }
}

private extension LoginViewController {
    
    func bindLoginSuccess() {
        viewModel.output.loginSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                guard let self else { return }

                switch type {
                case .kakao:
                    self.pushToOnboarding()
                case .dev:
                    self.switchRootToPotiTabBar()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindLoginFailure() {
        viewModel.output.loginFailure
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                PotiLogger.error(error)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Navigation

private extension LoginViewController {
    
    private func pushToOnboarding() {
//        let onboardingVC = OnboardingViewController()
//        navigationController?.pushViewController(onboardingVC, animated: true)
    }
}
