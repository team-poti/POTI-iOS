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
    
    private let loginView = LoginView()
    private let kakaoTap = PassthroughSubject<Void, Never>()

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
        let input = LoginViewModel.Input(
            kakaoLoginTap: kakaoTap.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginSuccess
            .sink {
                print("로그인 성공")
            }
            .store(in: &cancellables)
        
        output.loginFailure
            .sink {
                print("로그인 실패")
            }
            .store(in: &cancellables)
    }
}

extension LoginViewController {
    @objc private func kakaoLoginButtonTapped() {
        kakaoTap.send(())
    }
}
