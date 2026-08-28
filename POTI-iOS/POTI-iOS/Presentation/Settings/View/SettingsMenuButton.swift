//
//  SettingsMenuButton.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class SettingsMenuButton: UIControl {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let arrowImageView = UIImageView(image: .icnArrowRightLg)

    init(title: String, value: String? = nil, showsArrow: Bool = true) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        arrowImageView.isHidden = !showsArrow
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateValue(_ value: String) { valueLabel.text = value }

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
        valueLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray800
        }
        arrowImageView.do {
            $0.tintColor = .gray700
            $0.contentMode = .scaleAspectFit
        }
    }

    private func setUI() { addSubviews(titleLabel, valueLabel, arrowImageView) }

    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        valueLabel.snp.makeConstraints {
            $0.trailing.equalTo(arrowImageView.isHidden ? 0 : -32)
            $0.centerY.equalToSuperview()
        }
    }
}
