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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    
    // MARK: - Custom Method
    
    /// UI 컴포넌트 속성 설정 (do 메서드)
    override func setStyle() {
        
        // TODO: - 나연언니가 준 dynamicH 적용하기
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
    
    /// UI 위계 설정 (addSubview)
    override func setUI() {
        self.addSubviews(
            containerView,
            messageLabel
        )
    }
    
    /// 오토레이아웃 설정
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        messageLabel.snp.makeConstraints {
            $0.center.equalTo(containerView)
        }
    }
    
    func configure(text: String) {
        messageLabel.text = text
    }
}
