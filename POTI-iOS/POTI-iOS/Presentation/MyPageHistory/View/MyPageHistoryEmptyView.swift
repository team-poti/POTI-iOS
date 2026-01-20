//
//  MyPageHistoryEmptyView.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryEmptyView: BaseView {
    
    // MARK: - UI Components
    
    private let messageLabel = UILabel()
    
    // MARK: - Initializer
    
    init(message: String) {
        super.init(frame: .zero)
        
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        messageLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
    }
    
    override func setUI() {
        addSubview(messageLabel)
    }
    
    override func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.centerX.equalToSuperview()
        }
    }
}
