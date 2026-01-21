//
//  PotOrderContentView.swift.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class PotOrderContentView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let zipcodeLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    
    let nameField = CustomTextField.short(placeholder: "예) 이포티")
    let zipcodeField = CustomTextField.short(placeholder: "예) 12345")
    let addressField = CustomTextField.short(placeholder: "예) 서울시 솝트구 다솝로 37")
    let phoneField = CustomTextField.short(placeholder: "예) 010-1234-5678")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "참여자 정보"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }
        
        nameLabel.do {
            $0.text = "이름"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        
        zipcodeLabel.do {
            $0.text = "우편번호"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        
        addressLabel.do {
            $0.text = "주소"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        
        phoneLabel.do {
            $0.text = "연락처"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, nameLabel, nameField, zipcodeLabel, zipcodeField, addressLabel, addressField, phoneLabel, phoneField)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        nameField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        zipcodeLabel.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        zipcodeField.snp.makeConstraints {
            $0.top.equalTo(zipcodeLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(zipcodeField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        addressField.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(addressField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        phoneField.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}

