//
//  OnboardingDescriptionView.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingDescriptionView: BaseView {
    
    private let progressBar = UIImageView()
    private let descriptionLabel = UILabel()
//    private let cardImage = UIImageView()
    private let nextButton = PotiBottomButton()
    
    override func setStyle() {
        progressBar.do {
            $0.image = .imgOnboarding1
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.textColor = .potiBlack
            $0.numberOfLines = 2
            $0.setLabel(
                "분철 탐색부터 배송까지\n한 번에 관리해요",
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
        addSubviews(progressBar, descriptionLabel, nextButton)
    }
    
    override func setLayout() {
        progressBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(progressBar.snp.bottom).offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
}
