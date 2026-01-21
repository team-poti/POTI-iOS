//
//  StatusRowView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class StatusRowView: BaseView {
    
    // MARK: - UI
    
    private let statusLabel = UILabel()
    
    // MARK: - Init
    
    override func setStyle() {
        statusLabel.do {
            $0.font = PotiFontManager.body16sb.font
        }
    }
    
    override func setUI() {
        addSubview(statusLabel)
    }
    
    override func setLayout() {
        statusLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(depositInfo: MyPageJoinModel.PaymentInfo) {
        statusLabel.text = depositInfo.depositStatus.text
        statusLabel.textColor = depositInfo.depositStatus.badgeColor
    }
    
    func configure(shippingInfo: MyPageJoinModel.ShippingInfo) {
        statusLabel.text = shippingInfo.shippingStatus.text
        statusLabel.textColor = shippingInfo.shippingStatus.badgeColor
    }
}
