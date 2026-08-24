//
//  WithdrawalReasonRow.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class WithdrawalReasonRow: UIControl {
    private let titleLabel = UILabel()
    private let selectionContainerView = UIView()
    private let selectionBackgroundView = UIView()
    private let selectionDotView = UIView()

    override var isSelected: Bool {
        didSet { selectionBackgroundView.isHidden = !isSelected }
    }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        selectionBackgroundView.do {
            $0.backgroundColor = .poti200
            $0.layer.cornerRadius = 8
            $0.isHidden = true
        }
        selectionDotView.do {
            $0.backgroundColor = .poti600
            $0.layer.cornerRadius = 5
        }
    }

    private func setUI() {
        selectionBackgroundView.addSubview(selectionDotView)
        selectionContainerView.addSubview(selectionBackgroundView)
        addSubviews(titleLabel, selectionContainerView)
    }

    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(selectionContainerView.snp.leading).offset(-12)
        }
        selectionContainerView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        selectionBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(20)
        }
        selectionDotView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(10)
        }
    }
}
