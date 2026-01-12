//
//  FloatingButton.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import SnapKit

final class FloatingButton: UIButton {
    
    // MARK: - Property
    
    var action: (() -> Void)?
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setStyle()
        setLayout()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        self.setImage(.btnFloatingDefault, for: .normal)
        self.setImage(.btnFloatingPressed, for: .highlighted)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(56)
        }
    }
    
    private func addTarget() {
        self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // MARK: - Action Method
    
    @objc private func didTapButton() {
        action?()
    }
}
