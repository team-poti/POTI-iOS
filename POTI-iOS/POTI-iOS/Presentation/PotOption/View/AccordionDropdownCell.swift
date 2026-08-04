//
//  AccordionDropdownCell.swift
//  POTI-iOS
//
//  Created by soomin on 7/20/26.
//

import UIKit

import SnapKit
import Then

final class AccordionDropdownCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .potiWhite
        
        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        priceLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    
    private func setUI() {
        contentView.addSubviews(titleLabel, priceLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    
    func configure(with item: DropdownItem) {
        titleLabel.text = item.name
        priceLabel.text = "\(item.price.formattedWithComma)원"
        
        titleLabel.textColor = item.isEnabled ? .potiBlack : .gray700
        priceLabel.textColor = item.isEnabled ? .potiBlack : .gray700
        isUserInteractionEnabled = item.isEnabled
    }
}
