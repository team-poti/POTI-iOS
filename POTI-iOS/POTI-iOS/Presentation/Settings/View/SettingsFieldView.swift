//
//  SettingsFieldView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class SettingsFieldView: UIView {
    let textField = UITextField()
    let searchButton = UIButton(type: .system)
    var onBeginEditing: ((SettingsFieldView) -> Void)?
    private let titleLabel = UILabel()
    private let showsSearchButton: Bool

    init(title: String, placeholder: String, showsSearchButton: Bool = false) {
        self.showsSearchButton = showsSearchButton
        super.init(frame: .zero)
        titleLabel.text = title
        textField.placeholder = placeholder
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.backgroundColor = .potiWhite
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.cornerRadius = 8
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
            $0.leftViewMode = .always
            $0.delegate = self
        }
        searchButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(resource: .icnSearch).withRenderingMode(.alwaysTemplate)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
            $0.configuration = configuration
            $0.tintColor = .gray700
            $0.accessibilityLabel = "우편번호 검색"
            $0.isHidden = !showsSearchButton
        }
    }

    private func setUI() {
        addSubviews(titleLabel, textField, searchButton)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(22)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
        searchButton.snp.makeConstraints {
            $0.verticalEdges.trailing.equalTo(textField)
            $0.width.equalTo(56)
        }
    }

    func setReadOnly(_ readOnly: Bool) {
        textField.isUserInteractionEnabled = !readOnly
    }

    private func setFocused(_ focused: Bool) {
        textField.layer.borderColor = focused ? UIColor.potiBlack.cgColor : UIColor.gray300.cgColor
    }
}

extension SettingsFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFocused(true)
        onBeginEditing?(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setFocused(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
