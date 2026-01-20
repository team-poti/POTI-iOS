//
//  JoinTrackingNumberView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

/// 복사 아래 밑줄!!!!!!!!!!!!!!!!!
import UIKit

import SnapKit
import Then

final class JoinTrackingNumberView: BaseView {

    // MARK: - UI

    private let shipContainerView = UIView()
    private let shipLabel = UILabel()
    private let copyButton = UIButton()
    private let statusLabel = UILabel()

    // MARK: - Init

    // MARK: - Setup

    override func setStyle() {

        shipContainerView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }

        shipLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }

        copyButton.do {
            $0.setTitle("복사", for: .normal)
            $0.setUnderline()
            $0.setTitleColor(.gray700, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
        }
        
        statusLabel.do {
            $0.font = PotiFontManager.body16m.font
        }

        shipContainerView.addSubviews(shipLabel, copyButton)
    }
    
    // MARK: - SetUI
    
    override func setUI() {
        addSubviews(shipContainerView, statusLabel)
        shipContainerView.addSubviews(shipLabel, copyButton)
        copyButton.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
    }

    // MARK: - Layout

    override func setLayout() {
        shipContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }

        shipLabel.snp.makeConstraints {
            $0.leading.equalTo(shipContainerView.snp.leading).offset(16)
            $0.centerY.equalTo(shipContainerView)
        }

        copyButton.snp.makeConstraints {
            $0.trailing.equalTo(shipContainerView.snp.trailing).inset(16)
            $0.centerY.equalTo(shipContainerView)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(shipContainerView.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func configure(model: MyPageJoinModel) {
        shipLabel.text = model.shippingInfo.trackingNumber
        statusLabel.text = model.shippingInfo.shippingStatus.text
        statusLabel.textColor = model.shippingInfo.shippingStatus.badgeColor
    }
    
    @objc private func didTapCopy() {
        guard let text = shipLabel.text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }
}

