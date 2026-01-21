//
//  StatusMessageView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class StatusMessageView: BaseView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    
    // MARK: - Custom Method
    
    override func setStyle() {
        containerView.do {
            $0.backgroundColor = .poti200
            $0.layer.cornerRadius = 8
        }
        
        messageLabel.do {
            $0.textColor = .poti600
            $0.font = PotiFontManager.body14sb.font
            $0.textAlignment = .center
        }
    }
    
    override func setUI() {
        self.addSubviews(
            containerView,
            messageLabel
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        messageLabel.snp.makeConstraints {
            $0.center.equalTo(containerView)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(text: String) {
        messageLabel.text = text
    }
}
