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
    private let factory: ViewControllerFactory
    
    init(viewModel: LoginViewModel, factory: ViewControllerFactory) {
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
        rootView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        
        rootView.appleLoginButton.addTarget(self, action: #selector(devLoginButtonTapped), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        viewModel.output.navigateToOnboarding
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pushToOnboarding()
            }
            .store(in: &cancellables)
        
        viewModel.output.navigateToHome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.switchRootToPotiTabBar()
            }
            .store(in: &cancellables)
        
        viewModel.output.loginFailure
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
            }
            .store(in: &cancellables)
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

// MARK: - Navigation

private extension LoginViewController {
    
    private func pushToOnboarding() {
        let onboardingVC = factory.makeOnboardingViewController()
        
        if navigationController == nil {
            let navController = UINavigationController(rootViewController: onboardingVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        } else {
            navigationController?.pushViewController(onboardingVC, animated: true)
        }
    }
    
    private func switchRootToPotiTabBar() {
        PotiLogger.debug("홈화면으로 이동")
        let tabBar = factory.makePotiTabBar()
        switchRootViewController(to: tabBar)
    }
}
