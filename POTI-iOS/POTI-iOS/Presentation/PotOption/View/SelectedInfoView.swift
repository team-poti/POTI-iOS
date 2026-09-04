//
//  SelectedInfoView.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import SnapKit
import Then

enum Select {
    case Member
    case Delievery
}

final class SelectedInfoView: BaseView {
    
    // MARK: - Properties
    
    let type: Select
    var onDelete: (() -> Void)?
    
    // MARK: - UI Components
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    
    private let text: String
    private let price: String
    
    // MARK: - Initializer
    
    init(title: String, price: String, type: Select) {
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
        self.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
        
        iconImageView.do {
            let image = (type == .Member ? UIImage.icnMember : UIImage.icnDelivery).withRenderingMode(.alwaysTemplate)
            $0.image = image
            $0.tintColor = .gray800
        }
        
        titleLabel.do {
            $0.setLabel(text, font: .body14m, color: .gray800)
        }
        
        priceLabel.do {
            $0.setLabel(price, font: .body16sb, color: .potiBlack)
        }
        
        cancelButton.do {
            $0.setImage(.btnDeleteDark, for: .normal)
            $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            $0.isHidden = (type == .Delievery)
        }
    }
    
    override func setUI() {
        addSubviews(iconImageView, titleLabel, priceLabel, cancelButton)
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13.5)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(21)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(2)
            $0.top.equalTo(iconImageView).offset(-1.5)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        priceLabel.snp.makeConstraints {
            if type == .Delievery {
                $0.trailing.equalToSuperview().offset(-16)
            } else {
                $0.trailing.equalTo(cancelButton.snp.leading).offset(-8)
            }
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Method
    
    func updateData(title: String, price: String) {
        self.titleLabel.setLabel(title, font: .body14m, color: .gray800)
        self.priceLabel.setLabel(price, font: .body16sb, color: .potiBlack)
    }
    
    // MARK: - Action
    
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
}
