//
//  PotOrderContentView.swift.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class PotOrderContentView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let registerShipmentStackView = UIStackView()
    private let registerShipmentLabel = UILabel()
    private let registerShipmentButton = UIButton()
    
    private let nameLabel = UILabel()
    private let zipcodeLabel = UILabel()
    private let zipcodeIconView = UIImageView()
    private let addressLabel = UILabel()
    private let detailAddressLabel = UILabel()
    private let phoneLabel = UILabel()
    
    let nameField = CustomTextField.short(placeholder: "이름을 입력하세요")
    let zipcodeField = CustomTextField.short(placeholder: "우편번호를 입력하세요")
    let addressField = CustomTextField.short(placeholder: "주소를 입력하세요")
    let detailAddressField = CustomTextField.short(placeholder: "상세주소를 입력하세요")
    let phoneField = CustomTextField.short(placeholder: "연락처를 입력하세요")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        titleLabel.do {
            $0.setLabel("참여자 정보", font: .title18sb, color: .potiBlack)
        }
        
        registerShipmentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        registerShipmentLabel.do {
            $0.setLabel("내 배송지로 등록", font: .body14m, color: .gray900)
        }
        
        registerShipmentButton.do {
            $0.setImage(.btnCheckboxDefault, for: .normal)
            $0.setImage(.btnCheckboxSelected, for: .selected)
            $0.transform = CGAffineTransform(translationX: 0, y: 2)
        }

        nameLabel.do {
            $0.setLabel("이름", font: .body14sb, color: .potiBlack)
        }
        
        zipcodeLabel.do {
            $0.setLabel("우편번호", font: .body14sb, color: .potiBlack)
        }
        
        zipcodeIconView.do {
            $0.image = .icnSearch.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray700
        }
        
        addressLabel.do {
            $0.setLabel("주소", font: .body14sb, color: .potiBlack)
        }
        
        detailAddressLabel.do {
            $0.setLabel("상세주소", font: .body14sb, color: .potiBlack)
        }
        
        phoneLabel.do {
            $0.setLabel("연락처", font: .body14sb, color: .potiBlack)
        }
    }
    
    override func setUI() {
        registerShipmentStackView.addArrangedSubviews(registerShipmentButton, registerShipmentLabel)
        addSubviews(titleLabel, registerShipmentStackView, nameLabel, nameField, zipcodeLabel,
                    zipcodeField, zipcodeIconView, addressLabel, addressField,
                    detailAddressLabel, detailAddressField, phoneLabel, phoneField)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview()
        }
        
        registerShipmentButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        registerShipmentStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
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
        
        zipcodeIconView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.verticalEdges.equalTo(zipcodeField).inset(14)
            $0.trailing.equalTo(zipcodeField).offset(-16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(zipcodeField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        addressField.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        detailAddressLabel.snp.makeConstraints {
            $0.top.equalTo(addressField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        detailAddressField.snp.makeConstraints {
            $0.top.equalTo(detailAddressLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(detailAddressField.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        phoneField.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Private Method
    
    private func setAddTarget() {
        registerShipmentButton.addTarget(self, action: #selector(registerShipmentButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func registerShipmentButtonDidTap() {
        registerShipmentButton.isSelected.toggle()
    }
}
