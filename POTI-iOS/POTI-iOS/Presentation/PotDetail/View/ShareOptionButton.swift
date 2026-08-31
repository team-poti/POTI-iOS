//
//  ShareOptionButton.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit

import SnapKit
import Then

final class ShareOptionButton: UIControl {

    // MARK: - UI Components

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Initializer

    init(title: String, image: UIImage) {
        super.init(frame: .zero)

        configure(title: title, image: image)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setStyle() {
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }
    }

    private func setUI() {
        addSubviews(iconImageView, titleLabel)
    }

    private func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(64)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func configure(title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image
    }
}
