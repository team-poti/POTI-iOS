//
//  OrderHeaderRowView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

enum Kind {
    case Member
    case Delievery
}

final class OrderHeaderRowView: BaseView {
    
    // MARK: - Properties
    
    let type: Kind
    
    // MARK: - UI Components
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    // MARK: - Properties
    
    private let text: String
    private let price: String
    
    // MARK: - Initializer
    
    init(title: String, price: String, type: Kind) {
        self.text = title
        self.price = price
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        iconImageView.do {
            let image = (type == .Member ? UIImage.icnMember : UIImage.icnDelivery).withRenderingMode(.alwaysTemplate)
            $0.image = image
            $0.tintColor = .gray800
        }
        
        titleLabel.do {
            $0.text = text
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        priceLabel.do {
            $0.text = price
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
    }
    
    override func setUI() {
        addSubviews(iconImageView, titleLabel, priceLabel)
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(21)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    func updateData(title: String, price: String) {
        self.titleLabel.text = title
        self.priceLabel.text = price
    }
}

