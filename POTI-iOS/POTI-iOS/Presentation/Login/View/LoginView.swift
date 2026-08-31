//
//  LoginView.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {
    private let logo = UIImageView()
    let kakaoLoginButton = UIButton()
    let appleLoginButton = UIButton()
    let noLoginButton = UIButton()
    
    private lazy var buttonStack = UIStackView()
    
    override func setStyle() {
        logo.do {
            $0.image = .imgLoginLogo
            $0.contentMode = .scaleAspectFit
        }

        kakaoLoginButton.do {
            $0.setImage(.btnKakaoLogin, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }

        appleLoginButton.do {
            $0.setImage(.btnAppleLogin, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }

        buttonStack.do {
            $0.axis = .horizontal
            $0.spacing = 28
            $0.alignment = .center
        }

        noLoginButton.do {
            $0.setTitle("로그인 없이 둘러보기", for: .normal)
            $0.setTitleColor(.gray800, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
        }
    }

    override func setUI() {
        buttonStack.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
        addSubviews(logo, buttonStack, noLoginButton)
    }

    override func setLayout() {
        logo.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonStack.snp.top).offset(-115)
        }

        buttonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(140)
        }

        noLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStack.snp.bottom).offset(25.5)
        }
    }
}
