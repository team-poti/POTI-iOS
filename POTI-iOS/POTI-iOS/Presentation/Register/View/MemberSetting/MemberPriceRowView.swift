//
//  MemberPriceRowView.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

import UIKit

import SnapKit
import Then

final class MemberPriceRowView: BaseView {

    // MARK: - Properties

    var onAction: ((MemberSettingAction) -> Void)?
    var onInputFocus: ((UIView) -> Void)?
    private let memberID: Int

    // MARK: - UI Components

    private let nameLabel = UILabel()
    private let priceTextField = UITextField()
    private let underlineView = UIView()
    private let priceWonLabel = UILabel()

    // MARK: - Initializer

    init(memberID: Int) {
        self.memberID = memberID
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        nameLabel.do {
            $0.setLabel("", font: .body16m, color: .potiBlack)
        }

        priceTextField.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .right
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
        }

        underlineView.do {
            $0.backgroundColor = .gray300
        }

        priceWonLabel.do {
            $0.setLabel("원", font: .body16m, color: .potiBlack)
        }
    }

    override func setUI() {
        addSubviews(nameLabel, priceTextField, underlineView, priceWonLabel)
    }

    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(28)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }

        priceWonLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }

        priceTextField.snp.makeConstraints {
            $0.trailing.equalTo(priceWonLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(45)
            $0.height.equalTo(28)
        }

        underlineView.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(2)
            $0.horizontalEdges.equalTo(priceTextField)
            $0.height.equalTo(2)
        }
    }

    override func addTarget() {
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidBeginEditing), for: .editingDidBegin)
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidEndEditing), for: .editingDidEnd)
    }

    // MARK: - Custom Method

    func configure(name: String, price: Int?) {
        nameLabel.setLabel(name, font: .body16m, color: .potiBlack)
        priceTextField.text = price?.formattedWithComma
    }

    // MARK: - Actions

    @objc private func priceTextFieldDidChange() {
        let digits = priceTextField.text?.filter(\.isNumber) ?? ""

        guard let price = Int(digits) else {
            priceTextField.text = ""
            onAction?(.priceChanged(memberID: memberID, price: nil))
            return
        }

        priceTextField.text = price.formattedWithComma
        onAction?(.priceChanged(memberID: memberID, price: price))
    }

    @objc private func priceTextFieldDidBeginEditing() {
        onInputFocus?(priceTextField)
    }

    @objc private func priceTextFieldDidEndEditing() {
        let digits = priceTextField.text?.filter(\.isNumber) ?? ""
        priceTextField.text = Int(digits)?.formattedWithComma
    }
}
