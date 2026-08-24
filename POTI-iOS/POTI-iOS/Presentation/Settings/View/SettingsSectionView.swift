//
//  SettingsSectionView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class SettingsSectionView: UIView {
    private let titleLabel = UILabel()
    private let rowStackView = UIStackView()
    private let contentStackView = UIStackView()
    private let topInset: CGFloat

    init(title: String, rows: [UIView], topInset: CGFloat = 0) {
        self.topInset = topInset
        super.init(frame: .zero)
        titleLabel.text = title
        rows.forEach { rowStackView.addArrangedSubview($0) }
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        rowStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }

    private func setUI() {
        contentStackView.addArrangedSubviews(titleLabel, rowStackView)
        addSubview(contentStackView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topInset)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
