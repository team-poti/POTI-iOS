//
//  ShippingRowView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/17/26.
//

import UIKit

import SnapKit
import Then


final class ShippingRowView: BaseView {
    
    // MARK: - Initializer

    let index: Int
    init(index: Int = 0) {
        self.index = index
        super.init(frame: .zero)
        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components

    private let checkButton = UIButton()
    private let nameLabel = UILabel()
    private let priceTextField = UITextField()
    private let underlineView = UIView()
    private let wonLabel = UILabel()

    // MARK: - Custom Method

    private func formatNumberWithCommas(_ number: NSNumber) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: number)
    }

    override func setStyle() {
        backgroundColor = .clear

        checkButton.do {
            $0.setImage(UIImage(named: "btn-checkbox-default"), for: .normal)
            $0.setImage(UIImage(named: "btn-checkbox-selected"), for: .selected)
        }

        nameLabel.do {
            $0.text = ""
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.numberOfLines = 1
        }

        priceTextField.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .right
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.clearButtonMode = .never
        }

        underlineView.do {
            $0.backgroundColor = .gray300
        }

        wonLabel.do {
            $0.text = "원"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }

        priceTextField.isEnabled = false
        priceTextField.textColor = .potiBlack
        underlineView.backgroundColor = .gray300
    }

    override func setUI() {
        addSubviews(checkButton, nameLabel, priceTextField, underlineView, wonLabel)
    }

    override func setLayout() {
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(priceTextField)
            $0.size.equalTo(24)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(8)
            $0.centerY.equalTo(priceTextField)
            $0.height.equalTo(priceTextField)
        }

        wonLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(priceTextField.snp.centerY)
            $0.height.equalTo(priceTextField)
        }

        priceTextField.snp.makeConstraints {
            $0.trailing.equalTo(wonLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(45)
        }

        underlineView.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(priceTextField)
            $0.height.equalTo(2)
        }

        snp.makeConstraints {
            $0.height.equalTo(56)
        }
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        priceTextField.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func addTarget() {
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
    }

    // MARK: - Public

    func setName(_ name: String) {
        nameLabel.text = name
    }

    func setPrice(_ price: Int) {
        priceTextField.text = formatNumberWithCommas(NSNumber(value: price))
    }
    
    @objc private func didTapCheck() {
        checkButton.isSelected.toggle()
    }
    
    func configure(
        name: String,
        price: Int
    ) {
        setName(name)
        setPrice(price)
    }
}
