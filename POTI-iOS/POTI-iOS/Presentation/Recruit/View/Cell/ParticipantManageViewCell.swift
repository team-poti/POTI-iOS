//
//  ParticipantManageViewCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantManageViewCell: UITableViewCell {
    
    private let mockParticipantModel: ParticipantModel = ParticipantModel(
        purchaseId: 1110,
        memberNamesText: ["나연", "수민"],
        depositorNameText: "박정환",
        addressText: "(01010) 서울시 마포구 와우산로 54",
        phoneText: "010-1111-2222",
        shippingText: "준등기",
        totalPrice: 12500,
        depositStateText: .paid
    )
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        
        setUI()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Component
    
    private let membersLabel = UILabel()
    private let depositorInfoLabel = UILabel()
    private let shippingStackView = UIStackView()
    private let deliveryIconView = UIImageView()
    private let shippingLabel = UILabel()
    private let priceStackView = UIStackView()
    private let priceIconView = UIImageView()
    private let totalPriceLabel = UILabel()
    private let depositStateLabel = UILabel()

    // MARK: - Custom Method
    
    private func setStyle() {
        membersLabel.do {
            $0.setLabel(mockParticipantModel.memberNamesText.joined(separator: ", "), font: .body16m)
            $0.textColor = .potiBlack
        }
        
        depositorInfoLabel.do {
            $0.setLabel("\(mockParticipantModel.depositorNameText)\n\(mockParticipantModel.addressText)\n\(mockParticipantModel.phoneText)", font: .body14m)
            $0.numberOfLines = 0
            $0.textColor = .gray800
        }
        
        shippingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 2
        }

        deliveryIconView.do {
            $0.image = UIImage(named: "icn-delivery")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray800
        }

        shippingLabel.do {
            $0.text = mockParticipantModel.shippingText
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        priceStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 2
        }
        
        priceIconView.do {
            $0.image = UIImage(named: "icn-priceAngle")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray800
        }
        
        totalPriceLabel.do {
            $0.text = "\(mockParticipantModel.totalPrice.formattedWithComma)원"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        depositStateLabel.do {
            $0.setLabel(
                mockParticipantModel.depositStateText.badgeText,
                font: .body14m
            )
            $0.textColor = mockParticipantModel.depositStateText.badgeColor
        }
        
    }
    
    private func setUI() {
        shippingStackView.addArrangedSubviews(
            deliveryIconView,
            shippingLabel
        )

        priceStackView.addArrangedSubviews(
            priceIconView,
            totalPriceLabel
        )
        
        contentView.addSubviews(
            membersLabel,
            depositorInfoLabel,
            shippingStackView,
            priceStackView,
            depositStateLabel
        )
    }
    
    private func setLayout() {
        membersLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        depositStateLabel.snp.makeConstraints {
            $0.top.equalTo(membersLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        depositorInfoLabel.snp.makeConstraints {
            $0.top.equalTo(membersLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        shippingStackView.snp.makeConstraints {
            $0.top.equalTo(depositorInfoLabel.snp.bottom).offset(12)
            $0.leading.equalTo(depositorInfoLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
        deliveryIconView.snp.makeConstraints {
            $0.size.equalTo(21)
        }
        priceIconView.snp.makeConstraints {
            $0.size.equalTo(21)
        }
        priceStackView.snp.makeConstraints {
            $0.centerY.equalTo(shippingStackView)
            $0.leading.equalTo(shippingStackView.snp.trailing).offset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
