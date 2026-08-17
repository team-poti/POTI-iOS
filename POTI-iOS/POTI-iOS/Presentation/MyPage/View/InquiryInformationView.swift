//
//  InquiryInformationView.swift
//  POTI-iOS
//
//  Created by Neon on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class InquiryInformationView: BaseView {
    
    private let inquiryLabel = UILabel()
    private let inquiryButton = UIButton()
    
    override func setStyle() {
        backgroundColor = .potiWhite
        layer.cornerRadius = 12
        
        inquiryLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textAlignment = .center
            $0.textColor = .gray800
            $0.text = "궁금한 점이나 건의사항이 있다면 알려주세요"
        }
        
        inquiryButton.do {
            $0.setTitle("문의하기", for: .normal)
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14sb.font
            $0.backgroundColor = .potiBlack
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
    
    override func setUI() {
        addSubviews(inquiryLabel, inquiryButton)
    }
        
    override func setLayout() {
        inquiryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        inquiryButton.snp.makeConstraints {
            $0.top.equalTo(inquiryLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(123)
            $0.height.equalTo(CGFloat.dynamicH(48))
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
