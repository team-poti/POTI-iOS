//
//  DetailTextFieldView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class DetailTextFieldView: BaseView {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let customTextField = UITextField()

    // MARK: - Public

    var text: String {
        customTextField.text ?? ""
    }
    
    // MARK: - Custom Method
    
    override func setStyle() {
        
        titleLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14sb.font
            $0.textAlignment = .left
        }
        customTextField.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        setTextFieldInset(16)
    }
    
    override func setUI() {
        self.addSubviews(
            containerView,
            titleLabel,
            customTextField
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(containerView)
        }
        customTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(containerView)
            $0.height.equalTo(52)
        }
    }
    
    private func setTextFieldInset(_ inset: CGFloat) {
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: 1))
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: 1))

        customTextField.leftView = leftPadding
        customTextField.leftViewMode = .always

        customTextField.rightView = rightPadding
        customTextField.rightViewMode = .always
    }
    
    func configure(
        title: String,
        placeholder: String,
        placeholderColor: UIColor = .gray300
    ) {
        titleLabel.text = title
        customTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: PotiFontManager.body16m.font
            ]
        )
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        customTextField.keyboardType = type
    }
}
