//
//  OrderContentView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class OrderContentView: BaseView {
    
    // MARK: - UI Components
    
    let memberLabel = UILabel()
    let memberButton = UIButton(type: .system)
    let deliveryLabel = UILabel()
    let deliveryButton = UIButton(type: .system)
    let scrollContainerView = UIScrollView()
    let selectedStackView = UIStackView()
    let grayLineView = UIView()
    let totalPriceTextLabel = UILabel()
    let totalPriceNumberLabel = UILabel()
    let bottomButton = PotiBottomButton()
    let spacerView = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        selectedStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        memberLabel.do {
            $0.text = "멤버"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        
        memberButton.do {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString("분철 받을 멤버를 선택하세요", attributes: AttributeContainer([
                .font: PotiFontManager.body16m.font,
                .foregroundColor: UIColor.gray700
            ]))
            config.image = .icnArrowDownLg.withRenderingMode(.alwaysTemplate)
            config.imagePlacement = .trailing
            config.imageColorTransformer = .init { _ in return .gray700 }
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            $0.configuration = config
            $0.contentHorizontalAlignment = .fill
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
        }
        
        deliveryLabel.do {
            $0.text = "배송 방법"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        
        deliveryButton.do {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString("배송 방법을 선택하세요", attributes: AttributeContainer([
                .font: PotiFontManager.body16m.font,
                .foregroundColor: UIColor.gray700
            ]))
            config.image = .icnArrowDownLg.withRenderingMode(.alwaysTemplate)
            config.imagePlacement = .trailing
            config.imageColorTransformer = .init { _ in return .gray700 }
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            $0.configuration = config
            $0.contentHorizontalAlignment = .fill
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
        }
        
        grayLineView.do {
            $0.backgroundColor = .gray300
        }
        
        totalPriceTextLabel.do {
            $0.text = "총 입금 예정 금액"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        
        totalPriceNumberLabel.do {
            $0.font = PotiFontManager.display20b.font
            $0.textColor = .potiBlack
        }
        
        bottomButton.do {
            $0.color = .secondaryMain
            $0.isDisabled = true
            $0.text = "계속"
        }
        
        scrollContainerView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
        }
        
        selectedStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        spacerView.do {
            $0.backgroundColor = .clear
            $0.setContentHuggingPriority(.init(1), for: .vertical)
            $0.setContentCompressionResistancePriority(.init(1), for: .vertical)
        }
    }
    
    override func setUI() {
        addSubviews(memberLabel, memberButton, deliveryLabel, deliveryButton,
                    scrollContainerView, grayLineView, totalPriceTextLabel,
                    totalPriceNumberLabel, bottomButton)
        selectedStackView.addArrangedSubview(spacerView)
        scrollContainerView.addSubview(selectedStackView)
    }
    
    override func setLayout() {
        memberLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        memberButton.snp.makeConstraints {
            $0.top.equalTo(memberLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        deliveryLabel.snp.makeConstraints {
            $0.top.equalTo(memberButton.snp.bottom).offset(28)
            $0.leading.equalTo(memberLabel)
        }
        
        deliveryButton.snp.makeConstraints {
            $0.top.equalTo(deliveryLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(memberButton)
            $0.height.equalTo(52)
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        totalPriceTextLabel.snp.makeConstraints {
            $0.leading.equalTo(bottomButton)
            $0.bottom.equalTo(bottomButton.snp.top).offset(-20)
        }
        
        totalPriceNumberLabel.snp.makeConstraints {
            $0.trailing.equalTo(bottomButton)
            $0.centerY.equalTo(totalPriceTextLabel)
        }
        
        grayLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(totalPriceTextLabel.snp.top).offset(-18)
        }
        
        scrollContainerView.snp.makeConstraints {
            $0.bottom.equalTo(grayLineView.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(216)
        }
        
        selectedStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollContainerView.contentLayoutGuide)
            $0.width.equalTo(scrollContainerView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollContainerView.snp.height)
        }
    }
}
