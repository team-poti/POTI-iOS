//
//  MemberPriceRowView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/17/26.
//

import UIKit

import SnapKit
import Then


final class MemberPriceRowView: BaseView {
    
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

        nameLabel.do {
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
    }

    override func setUI() {
        addSubviews(nameLabel, priceTextField, underlineView, wonLabel)
    }

    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(priceTextField.snp.centerY)
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
        priceTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }


    // MARK: - Action Method

    @objc private func didChangeText() {
        let rawText = priceTextField.text ?? ""
        let digits = rawText.replacingOccurrences(of: ",", with: "")

        guard let number = Int(digits) else {
            priceTextField.text = ""
            return
        }

        let formatted = formatNumberWithCommas(NSNumber(value: number)) ?? ""
        priceTextField.text = formatted
    }

    // MARK: - Public

    var currentPrice: Int? {
        let text = priceTextField.text ?? ""
        let digits = text.replacingOccurrences(of: ",", with: "")
        return Int(digits)
    }

    func configure(
        name: String,
        price: Int?
    ) {
        nameLabel.text = name

        if let price, let formatted = formatNumberWithCommas(NSNumber(value: price)) {
            priceTextField.text = formatted
        } else {
            priceTextField.text = ""
        }
    }

    @available(*, deprecated, message: "configure(name:price:)를 사용하세요.")
    func setName(_ name: String) {
        nameLabel.text = name
    }

    @available(*, deprecated, message: "configure(name:price:)를 사용하세요.")
    func setPrice(_ text: String) {
        priceTextField.text = text
    }
}
