//
//  RowView.swift
//  POTI-iOS
//
//  Created by mandoo on 6/11/26.
//

import UIKit

import SnapKit
import Then

final class RowView: UIView {

    // MARK: - UI Components

    let titleLabel = UILabel()
    let valueStackView = UIStackView()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }

        valueStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
    }

    private func setUI() {
        addSubviews(titleLabel, valueStackView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(77)
        }

        valueStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
    }

    // MARK: - Public Configure Methods

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let label = createValueLabel(with: value)
        valueStackView.addArrangedSubview(label)
    }

    func configureWithDivider(title: String, values: [String]) {
        titleLabel.text = title
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, value) in values.enumerated() {
            let label = createValueLabel(with: value)
            valueStackView.addArrangedSubview(label)

            if index < values.count - 1 {
                let divider = createVerticalDivider()
                valueStackView.addArrangedSubview(divider)
            }
        }
    }

    // MARK: - Private Factory Methods

    private func createValueLabel(with text: String) -> UILabel {
        return UILabel().then {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
            $0.text = text
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    }

    private func createVerticalDivider() -> UIView {
        return UIView().then {
            $0.backgroundColor = .gray800
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(21)
            }
        }
    }
}
