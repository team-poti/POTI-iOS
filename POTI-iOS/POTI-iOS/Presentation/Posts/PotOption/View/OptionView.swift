//
//  OptionView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class OptionView: BaseView {
    
    // MARK: - UI Components
    
    let backgroundView = UIView()
    let containerView = UIView()
    let closeButton = UIButton()
    let contentView = OptionContentView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.6)
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        closeButton.setImage(.icnX, for: .normal)
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(closeButton, contentView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(750)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(4)
            $0.size.equalTo(48)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
