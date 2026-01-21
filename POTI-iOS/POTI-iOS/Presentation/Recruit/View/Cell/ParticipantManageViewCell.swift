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
    
    struct Model {
            let memberNamesText: [String]
            let depositorNameText: String
            let addressText: String
            let phoneText: String
            let shippingText: String
            let totalPrice: Int
            let depositState: ParticipantStatus
        }
    
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

    private func setStyle() {
        membersLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        
        depositorInfoLabel.do {
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
            $0.font = PotiFontManager.body14m.font
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
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        depositStateLabel.do {
            $0.font = PotiFontManager.body14m.font
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
    
    func configure(model: Model) {
        membersLabel.text = model.memberNamesText.joined(separator: ", ")

        let text = [
            model.depositorNameText,
            model.addressText,
            model.phoneText
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6   // TODO: 디자인 확정 시 조정 0120

        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: PotiFontManager.body14m.font,
                .foregroundColor: UIColor.gray800,
                .paragraphStyle: paragraphStyle
            ]
        )
        depositorInfoLabel.attributedText = attributedText
        depositorInfoLabel.numberOfLines = 0
        shippingLabel.text = model.shippingText
        totalPriceLabel.text = "\(model.totalPrice.formattedWithComma)원"
        depositStateLabel.text = model.depositState.badgeText
        depositStateLabel.textColor = model.depositState.badgeColor
    }
    
    ///configure로 빼자!! 0120
//    func configure(model: Model) {
//        membersLabel.text = model.memberNamesText.joined(separator: ", ")
//        depositorInfoLabel.text = "\(model.depositorNameText)\n\(model.addressText)\n\(model.phoneText)"
//        depositorInfoLabel.numberOfLines = 0
//        shippingLabel.text = model.shippingText
//        totalPriceLabel.text = "\(model.totalPrice.formattedWithComma)원"
//        depositStateLabel.text = model.depositState.badgeText
//        depositStateLabel.textColor = model.depositState.badgeColor
//    }
}

// MARK: - Mock

extension ParticipantManageViewCell.Model {

    /// 기본 케이스 (입금 대기)
    static let mockWaitPay: ParticipantManageViewCell.Model = .init(
        memberNamesText: ["제니", "로제", "지수", "리사"],
        depositorNameText: "김서현",
        addressText: "(06000) 서울시 강남구 압구정로 77",
        phoneText: "010-5555-6666",
        shippingText: "일반택배",
        totalPrice: 40000,
        depositState: .waitPay
    )

    /// 입금 확인중
    static let mockWaitPayCheck: ParticipantManageViewCell.Model = .init(
        memberNamesText: ["안유진"],
        depositorNameText: "이서현",
        addressText: "(04524) 서울시 중구 세종대로 110",
        phoneText: "010-1111-2222",
        shippingText: "준등기",
        totalPrice: 15000,
        depositState: .waitPayCheck
    )

    /// 입금 완료
    static let mockPaid: ParticipantManageViewCell.Model = .init(
        memberNamesText: ["장원영", "레이"],
        depositorNameText: "김민지",
        addressText: "(06236) 서울시 강남구 테헤란로 152",
        phoneText: "010-3333-4444",
        shippingText: "일반택배",
        totalPrice: 28000,
        depositState: .paid
    )

    /// 배송 시작
    static let mockStartShip: ParticipantManageViewCell.Model = .init(
        memberNamesText: ["카리나", "윈터", "지젤"],
        depositorNameText: "박지은",
        addressText: "(04147) 서울시 마포구 양화로 45",
        phoneText: "010-7777-8888",
        shippingText: "CJ대한통운",
        totalPrice: 36000,
        depositState: .startShip
    )

    /// 배송 완료
    static let mockCompleted: ParticipantManageViewCell.Model = .init(
        memberNamesText: ["민지", "하니", "다니엘", "해린", "혜인"],
        depositorNameText: "정수진",
        addressText: "(03027) 서울시 종로구 사직로 161",
        phoneText: "010-9999-0000",
        shippingText: "우체국택배",
        totalPrice: 52000,
        depositState: .completed
    )

    /// Preview / 기본 사용용
    static let mock: ParticipantManageViewCell.Model = mockWaitPay
}
