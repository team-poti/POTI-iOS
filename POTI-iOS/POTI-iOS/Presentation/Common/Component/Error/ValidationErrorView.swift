//
//  ValidationErrorView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import SnapKit
import Then

final class ValidationErrorView: BaseView {

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
            $0.alignment = .top
            $0.distribution = .fill
        }

        iconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icnNotice
            $0.tintColor = .sementicRed
        }

        messageLabel.do {
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
            $0.size.equalTo(24)
        }
    }

    // MARK: - Public Method

    func setMessage(_ message: String?) {
        messageLabel.setLabel(message ?? "", font: .body14m, color: .sementicRed)
        isHidden = message == nil
    }
}
