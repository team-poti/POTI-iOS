//
//  CustomAlertView.swift
//  POTI-iOS
//
//  Created by neon on 1/21/26.
//


import UIKit

import SnapKit
import Then

final class CustomAlertView: BaseView {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .potiWhite
        $0.layer.cornerRadius = 12
    }
    
    private let titleLabel = UILabel().then {
        $0.font = PotiFontManager.body16sb.font
        $0.textColor = .potiBlack
        $0.textAlignment = .center
    }
    
    private let messageLabel = UILabel().then {
        $0.font = PotiFontManager.body16m.font
        $0.textColor = .gray800
        $0.textAlignment = .center
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let leftButton = UIButton().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.titleLabel?.font = PotiFontManager.button16sb.font
        $0.setTitleColor(.gray900, for: .normal)
    }
    
    private let rightButton = UIButton().then {
        $0.backgroundColor = .poti600
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.titleLabel?.font = PotiFontManager.button16sb.font
        $0.setTitleColor(.potiWhite, for: .normal)
    }
    
    // MARK: - Properties
    
    private var onLeftButton: (() -> Void)?
    private var onRightButton: (() -> Void)?
    
    // MARK: - Initializer
    
    init(
        title: String,
        message: String,
        cancelTitle: String,
        confirmTitle: String,
        onLeftButton: @escaping () -> Void,
        onRightButton: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        
        self.onLeftButton = onLeftButton
        self.onRightButton = onRightButton
        
        titleLabel.text = title
        messageLabel.text = message
        leftButton.setTitle(cancelTitle, for: .normal)
        rightButton.setTitle(confirmTitle, for: .normal)
        
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(leftButton, rightButton)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Private Methods
    
    private func addTarget() {
        leftButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        dismiss()
        onLeftButton?()
    }
    
    @objc private func confirmTapped() {
        dismiss()
        onRightButton?()
    }
    
    // MARK: - Public Methods
    
    func show(on view: UIView) {
        frame = view.bounds
        alpha = 0
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
