//
//  LoginViewController.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    private let loginView = LoginView()

    override func setUI() {
        view.addSubview(loginView)
    }
    
    override func setLayout() {
        loginView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func addTarget() {
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        guard let viewModel else { return }
        let output = viewModel.transform(input: .didTapKakaoLogin)
        output.loginSuccess
            .sink { [weak self] in
                // TODO: 홈 화면 전환
                PotiLogger.debug("로그인 성공")
            }
            .store(in: &cancellables)
        
        output.loginFailure
            .sink {
                PotiLogger.debug("로그인 실패")
            }
            .store(in: &cancellables)
    }
}

extension LoginViewController {
    @objc private func kakaoLoginButtonTapped() {
        guard let viewModel else { return }
        _ = viewModel.transform(input: .didTapKakaoLogin)
    }
}
