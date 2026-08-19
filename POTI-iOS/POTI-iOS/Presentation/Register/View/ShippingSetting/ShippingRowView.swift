//
//  ShippingRowView.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

import UIKit

import SnapKit
import Then

final class ShippingRowView: BaseView {

    // MARK: - Properties

    var onAction: ((ShippingSettingAction) -> Void)?
    private let deliveryMethodID: Int

    // MARK: - UI Components

    private let checkButton = UIButton()
    private let nameLabel = UILabel()
    private let priceTextField = UITextField()
    private let underlineView = UIView()
    private let wonLabel = UILabel()

    // MARK: - Initializerd

    init(deliveryMethodID: Int) {
        self.deliveryMethodID = deliveryMethodID
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear

        checkButton.do {
            $0.setImage(.btnCheckboxDefault, for: .normal)
            $0.setImage(.btnCheckboxSelected, for: .selected)
        }

        nameLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
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
            $0.height.equalTo(28)
        }
    }

    override func addTarget() {
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidBeginEditing), for: .editingDidBegin)
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidEndEditing), for: .editingDidEnd)
    }

    // MARK: - Public Method

    func render(_ option: RegisterShippingOptionItem) {
        nameLabel.text = option.name
        checkButton.isSelected = option.isSelected
        guard !priceTextField.isFirstResponder else { return }
        priceTextField.text = option.price?.formattedWithComma
    }

    // MARK: - Actions

    @objc private func didTapCheck() {
        onAction?(.selectionToggled(deliveryMethodID: deliveryMethodID))
    }

    @objc private func priceTextFieldDidChange() {
        let digits = priceTextField.text?.filter(\.isNumber) ?? ""
        guard let price = Int(digits) else {
            priceTextField.text = ""
            onAction?(.priceChanged(deliveryMethodID: deliveryMethodID, price: nil))
            return
        }

        priceTextField.text = price.formattedWithComma
        onAction?(.priceChanged(deliveryMethodID: deliveryMethodID, price: price))
    }

    @objc private func priceTextFieldDidBeginEditing() {
        onAction?(.inputFocused(priceTextField))
    }

    @objc private func priceTextFieldDidEndEditing() {
        let digits = priceTextField.text?.filter(\.isNumber) ?? ""
        priceTextField.text = Int(digits)?.formattedWithComma
    }
}
