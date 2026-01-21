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
    
    // MARK: - UI Component
    
    private let shipContainerView = UIView()
    private let shipLabel = UILabel()
    private let copyButton = UIButton()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setStyle
    
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
            $0.setTitleColor(.gray700, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
        }
        
        statusLabel.do {
            $0.font = PotiFontManager.body16m.font
        }
    }
    
    // MARK: - SetUI
    
    override func setUI() {
        addSubviews(shipContainerView, statusLabel)
        shipContainerView.addSubviews(shipLabel, copyButton)
        shipContainerView.addSubviews(shipLabel, copyButton)
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
    
    private func addTarget() {
        copyButton.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
    }
    
    @objc private func didTapCopy() {
        guard let text = shipLabel.text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }
}
