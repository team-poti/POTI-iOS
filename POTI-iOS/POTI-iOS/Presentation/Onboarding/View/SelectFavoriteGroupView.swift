//
//  SelectFavoriteGroupView.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SelectFavoriteGroupView: BaseView {
    
    private let progressBar = UIImageView()
    private let descriptionLabel = UILabel()
//    private let cardImage = UIImageView()
    let skipButton = PotiBottomButton()
    let startButton = PotiBottomButton()
    
    override func setStyle() {
        progressBar.do {
            $0.image = .imgOnboarding3
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.textColor = .potiBlack
            // TODO: - 나중에 텍스트필드에 적은 닉네임 델리게이트로 보내기
            $0.text = "포티님의 최애 그룹 한 팀을 선택해주세요"
            $0.font = PotiFontManager.title18sb.font
        }
        
        // TODO: - 셀 불러오기
        
        skipButton.do {
            $0.size = .small
            $0.color = .primarySub
            $0.text = "건너뛰기"
        }
        
        startButton.do {
            $0.size = .medium
            $0.color = .primaryMain
            $0.text = "시작하기"
        }
    }
    
    override func setUI() {
        addSubviews(progressBar, descriptionLabel, skipButton, startButton)
    }
    
    override func setLayout() {
        progressBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(progressBar.snp.bottom).offset(24)
        }
        
        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        startButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
}
