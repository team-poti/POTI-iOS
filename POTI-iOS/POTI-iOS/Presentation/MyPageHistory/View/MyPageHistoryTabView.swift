//
//  MyPageHistoryTabView.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryTabView: BaseView {
    
    // MARK: - UI Components
    
    private let ongoingCountLabel = UILabel()
    private let ongoingTitleLabel = UILabel()
    let ongoingTabButton = UIButton()
    
    private let completedCountLabel = UILabel()
    private let completedTitleLabel = UILabel()
    let completedTabButton = UIButton()
    
    let tabIndicator = UIView()
    private let tabDivider = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        ongoingCountLabel.do {
            $0.font = PotiFontManager.display18b.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        ongoingTitleLabel.do {
            $0.text = "진행 중"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        ongoingTabButton.do {
            $0.tag = 0
            $0.backgroundColor = .clear
        }
        
        // 종료 탭
        completedCountLabel.do {
            $0.font = PotiFontManager.display18b.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        completedTitleLabel.do {
            $0.text = "종료"
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        completedTabButton.do {
            $0.tag = 1
            $0.backgroundColor = .clear
        }
        
        tabIndicator.do {
            $0.backgroundColor = .poti600
        }
        
        tabDivider.do {
            $0.backgroundColor = .gray300
        }
    }
    
    override func setUI() {
        addSubviews(ongoingCountLabel, ongoingTitleLabel, ongoingTabButton, completedCountLabel, completedTitleLabel, completedTabButton, tabIndicator, tabDivider)
    }
    
    override func setLayout() {
        ongoingCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        ongoingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ongoingCountLabel.snp.bottom).offset(2)
            $0.centerX.equalTo(ongoingCountLabel)
        }
        
        // 진행 중 버튼
        ongoingTabButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        // 종료 카운트 & 타이틀
        completedCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        completedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(completedCountLabel.snp.bottom).offset(2)
            $0.centerX.equalTo(completedCountLabel)
        }
        
        // 종료 버튼
        completedTabButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        // 인디케이터
        tabIndicator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(ongoingTabButton)
            $0.width.equalTo(ongoingTabButton)
            $0.height.equalTo(2)
        }
        
        tabDivider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    func updateTabIndicator(to button: UIButton, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.tabIndicator.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(button)
                $0.width.equalTo(button)
                $0.height.equalTo(2)
            }
            self.layoutIfNeeded()
        }
    }
    
    func updateTabSelection(tab: MyPageHistoryViewController.HistoryTab) {
        switch tab {
        case .ongoing:
            ongoingCountLabel.textColor = .potiBlack
            ongoingTitleLabel.textColor = .potiBlack
            completedCountLabel.textColor = .gray700
            completedTitleLabel.textColor = .gray700
        case .completed:
            ongoingCountLabel.textColor = .gray700
            ongoingTitleLabel.textColor = .gray700
            completedCountLabel.textColor = .potiBlack
            completedTitleLabel.textColor = .potiBlack
        }
    }
    
    func updateCount(for tab: MyPageHistoryViewController.HistoryTab, count: Int) {
        switch tab {
        case .ongoing:
            ongoingCountLabel.text = "\(count)"
        case .completed:
            completedCountLabel.text = "\(count)"
        }
    }
}
