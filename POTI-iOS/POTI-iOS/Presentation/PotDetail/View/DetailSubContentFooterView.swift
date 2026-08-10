//
//  DetailSubContentFooterView.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DetailSubContentFooterView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let grayLineView = UIView()
    private let shareStackView = UIStackView()
    private let shareIconView = UIImageView()
    private let shareLabel = UILabel()
    private let noticeView = NoticeView(type: .participate)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        grayLineView.do {
            $0.backgroundColor = .gray100
        }
        
        shareStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        shareIconView.do {
            $0.image = .icnShare
        }
        
        shareLabel.do {
            $0.text = "이 분철팟 공유하기"
            $0.font = PotiFontManager.button14sb.font
            $0.textColor = .gray800
        }
    }
    
    private func setUI() {
        shareStackView.addArrangedSubviews(shareIconView, shareLabel)
        addSubviews(grayLineView, shareStackView, noticeView)
    }
    
    private func setLayout() {
        grayLineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(-16)
            $0.height.equalTo(8)
        }
        
        shareIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        shareStackView.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(shareStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
    }
}
