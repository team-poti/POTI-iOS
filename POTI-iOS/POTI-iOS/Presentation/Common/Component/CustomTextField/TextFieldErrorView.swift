//
//  TextFieldErrorView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import SnapKit
import Then

final class TextFieldErrorView: BaseView {

    // MARK: - UI Components

    private let stackView = UIStackView()
    private let iconView = UIImageView()
    private let messageLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        isHidden = true

        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fill
        }

        iconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icnNotice
            $0.tintColor = .sementicRed
        }

        messageLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(iconView, messageLabel)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }

    // MARK: - Public Methods

    func show(message: String) {
        messageLabel.text = message
        isHidden = false
    }

    func hide() {
        messageLabel.text = nil
        isHidden = true
    }
}
