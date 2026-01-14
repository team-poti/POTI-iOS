//
//  IconStackView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class IconStackView: BaseView {
    
    enum IconFontSizeCase {
        case small
        case large
    }
    
    private let iconName: String
    private let title: String
    private let price: Int
    private let fontSizeCase: IconFontSizeCase
    
    init(iconName: String, title: String, price: Int,fontSizeCase: IconFontSizeCase = .small) {
        self.iconName = iconName
        self.title = title
        self.fontSizeCase = fontSizeCase
        self.price = price
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let iconStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    override func setStyle() {
        iconStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 2
        }
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray800
            
        }
        titleLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
            $0.text = title
        }
        priceLabel.do {
            $0.text = "\(price.formattedWithComma)원"
            $0.textColor = .potiBlack
            switch fontSizeCase {
            case .small:
                $0.font = PotiFontManager.body14m.font
            case .large:
                $0.font = PotiFontManager.body16sb.font
            }
        }
    }
    
    override func setUI() {
        self.addSubviews(
            iconStackView,
            priceLabel
        )
    }
    
    override func setLayout() {
        iconStackView.addArrangedSubviews(
            iconImageView,
            titleLabel
        )
        
        iconStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(21)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconStackView)
            $0.trailing.equalToSuperview()
        }
    }
}
