//
//  RowView.swift
//  POTI-iOS
//
//  Created by soomin on 6/11/26.
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
            $0.setLabel("", font: .body14m, color: .gray800)
        }

        valueStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
        }
    }

    private func setUI() {
        addSubviews(titleLabel, valueStackView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.equalTo(77)
        }

        valueStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }

    // MARK: - Public Configure Methods

    func configure(title: String, value: String) {
        titleLabel.setLabel(title, font: .body14m, color: .gray800)
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let label = createValueLabel(with: value)
        valueStackView.addArrangedSubview(label)
        invalidateIntrinsicContentSize()
    }

    func configureWithDivider(title: String, values: [String]) {
        titleLabel.setLabel(title, font: .body14m, color: .gray800)
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        valueStackView.addArrangedSubview(WrappingOptionsView(values: values))
        invalidateIntrinsicContentSize()
    }

    // MARK: - Private Factory Methods

    private func createValueLabel(with text: String) -> UILabel {
        return UILabel().then {
            $0.setLabel(text, font: .body14m, color: .potiBlack)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
