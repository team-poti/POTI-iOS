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
    }
    
    override func setUI() {
        buttonStack.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
        addSubviews(logo, buttonStack)
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
    }
}
