//
//  ValidNicknameView.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ValidNicknameView: BaseView {
    
    private let progressBar = UIImageView()
    private let descriptionLabel = UILabel()
    private let validTextField = CustomTextField.count(placeholder: "닉네임을 입력해주세요", max: 10)
    let nextButton = PotiBottomButton()
    
    override func setStyle() {
        progressBar.do {
            $0.image = .imgOnboarding2
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.textColor = .potiBlack
            $0.numberOfLines = 2
            $0.setLabel(
                "포티에서 사용할 닉네임을\n입력해주세요",
                font: .title18sb
            )
        }
        
        nextButton.do {
            $0.size = .large
            $0.color = .primaryMain
            $0.text = "다음"
        }
    }
    
    override func setUI() {
        addSubviews(progressBar, descriptionLabel, validTextField, nextButton)
    }
    
    override func setLayout() {
        progressBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(progressBar.snp.bottom).offset(24)
        }
        
        validTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
}
