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
}
