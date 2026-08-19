//
//  FloatingButton.swift
//  POTI-iOS
//
//  Created by soomin on 1/13/26.
//

import UIKit

import SnapKit

final class FloatingButton: UIButton {
    
    // MARK: - Property
    
    var onTap: (() -> Void)?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
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
    
    private func addTarget() {
        self.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action Method
    
    @objc private func floatingButtonTapped() {
        onTap?()
    }
}
