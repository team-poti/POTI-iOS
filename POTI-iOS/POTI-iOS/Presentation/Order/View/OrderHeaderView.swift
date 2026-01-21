//
//  OrderHeaderView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class OrderHeaderView: BaseView {
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView()
    private let grayLineView = UIView()
    private let totalPriceTextLabel = UILabel()
    private let totalPriceNumberLabel = UILabel()
    private let totalContainerView = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .fill
            $0.alignment = .fill
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
    }
    
    override func setUI() {
        addSubviews(contentStackView, grayLineView, totalContainerView)
        totalContainerView.addSubviews(totalPriceTextLabel, totalPriceNumberLabel)
    }
    
    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        grayLineView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalContainerView.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }
        
        totalPriceTextLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        totalPriceNumberLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    func configure(items: [(type: Kind, title: String, price: String)], totalAmount: String) {
        contentStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        items.forEach { item in
            let row = OrderHeaderRowView(title: item.title, price: item.price, type: item.type)
            contentStackView.addArrangedSubview(row)
        }

        totalPriceNumberLabel.text = totalAmount
    }
}
