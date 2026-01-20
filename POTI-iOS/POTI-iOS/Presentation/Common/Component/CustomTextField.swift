//
//  CustomTextField.swift
//  POTI-iOS
//

import UIKit

import SnapKit
import Then

final class CustomTextField: BaseView {

    // MARK: - Property

    var onTapField: (() -> Void)?
    private(set) var variant: TextFieldVariant = .short
    private var uiState: TextFieldUIState = .normal
    private var isTapOnly: Bool = false

    // MARK: - UI Components

    private let rootStackView = UIStackView()

    private let containerView = UIView()
    private let textField = UITextField()

    private let rightAccessoryContainer = UIView()
    private let rightIconView = UIImageView()
    private let countLabel = UILabel()

    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    private var textFieldTrailingToAccessory: Constraint?
    private var textFieldTrailingToSuperview: Constraint?

    // MARK: - Private Setup

    override func setStyle() {
        backgroundColor = .clear
        clipsToBounds = false
        containerView.clipsToBounds = false

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }

        rootStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }

        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        rightIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray700
            $0.isHidden = true
        }

        countLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.textAlignment = .right
            $0.isHidden = true
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }

        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fill
            $0.isHidden = true
        }

        errorIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icnNotice
            $0.tintColor = .sementicRed
        }

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        containerView.addGestureRecognizer(tap)
    }

    override func setUI() {
        addSubview(rootStackView)

        rootStackView.addArrangedSubviews(containerView, errorStackView)
        containerView.addSubviews(textField, rightAccessoryContainer)
        rightAccessoryContainer.addSubviews(rightIconView, countLabel)
        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
    }

    override func setLayout() {
        rootStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(52)
        }

        rightAccessoryContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(24)
            $0.width.equalTo(24).priority(750)
        }

        rightIconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        countLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)

            textFieldTrailingToAccessory = $0.trailing.equalTo(rightAccessoryContainer.snp.leading).offset(-8).constraint
            textFieldTrailingToSuperview = $0.trailing.equalToSuperview().inset(16).constraint
        }

        textFieldTrailingToSuperview?.deactivate()

        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }

    // MARK: - Custom Method

    func configure(
        variant: TextFieldVariant,
        placeholder: String? = nil,
        isTapOnly: Bool = false
    ) {
        self.variant = variant
        self.isTapOnly = isTapOnly

        if let placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: PotiFontManager.body16m.font,
                    .foregroundColor: UIColor.gray700
                ]
            )
        } else {
            textField.attributedPlaceholder = nil
        }

        applyVariant()
        apply(state: uiState)
    }

    func apply(state: TextFieldUIState) {
        uiState = state

        switch state {
        case .normal:
            containerView.layer.borderColor = UIColor.gray300.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true

        case .focused:
            containerView.layer.borderColor = UIColor.potiBlack.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true

        case .error(let message):
            containerView.layer.borderColor = UIColor.sementicRed.cgColor
            errorLabel.text = message
            errorStackView.isHidden = false
        }
    }

    func setText(_ text: String?) {
        textField.text = text
        updateCountIfNeeded()
    }

    func getText() -> String {
        return textField.text ?? ""
    }

    func updateCount(current: Int, max: Int) {
        countLabel.text = "\(current)/\(max)"
    }

    // MARK: - Private Method

    private func applyVariant() {
        rightIconView.isHidden = true
        countLabel.isHidden = true
        rightAccessoryContainer.isHidden = true

        // 기본은 입력 가능. 단, searchNavigate 또는 tapOnly면 키보드 입력을 막고 탭으로만 처리
        if isTapOnly {
            textField.isUserInteractionEnabled = false
        } else {
            switch variant {
            case .searchNavigate:
                textField.isUserInteractionEnabled = false
            default:
                textField.isUserInteractionEnabled = true
            }
        }

        containerView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(52)
        }

        switch variant {
        case .searchNavigate:
            rightIconView.isHidden = false
            rightIconView.image = .icnSearch

        case .count(let max):
            countLabel.isHidden = false
            countLabel.text = "0/\(max)"

        case .short:
            break
        }

        let hasAccessory = (!rightIconView.isHidden) || (!countLabel.isHidden)

        if hasAccessory {
            rightAccessoryContainer.isHidden = false
            textFieldTrailingToSuperview?.deactivate()
            textFieldTrailingToAccessory?.activate()
        } else {
            rightAccessoryContainer.isHidden = true
            textFieldTrailingToAccessory?.deactivate()
            textFieldTrailingToSuperview?.activate()
        }
        updateCountIfNeeded()
    }

    private func updateCountIfNeeded() {
        guard case .count(let max) = variant else { return }
        let count = getText().count
        countLabel.text = "\(count)/\(max)"
    }

    // MARK: - Action Method

    @objc private func didTapField() {
        if isTapOnly {
            onTapField?()
            return
        }

        switch variant {
        case .searchNavigate:
            onTapField?()
        default:
            break
        }
    }
}

extension CustomTextField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        apply(state: .focused)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        apply(state: .normal)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if case .count(let max) = variant {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return true }
            let next = current.replacingCharacters(in: r, with: string)
            if next.count > max { return false }

            updateCount(current: next.count, max: max)
            return true
        }
        return true
    }
}

extension CustomTextField {

    convenience init(
        variant: TextFieldVariant,
        placeholder: String? = nil,
        isTapOnly: Bool = false,
        onTapField: (() -> Void)? = nil
    ) {
        self.init(frame: .zero)
        configure(variant: variant, placeholder: placeholder, isTapOnly: isTapOnly)
        self.onTapField = onTapField
    }

    static func searchNavigate(
        placeholder: String,
        onTapField: (() -> Void)? = nil
    ) -> CustomTextField {
        CustomTextField(
            variant: .searchNavigate,
            placeholder: placeholder,
            onTapField: onTapField
        )
    }

    static func count(
        placeholder: String,
        max: Int
    ) -> CustomTextField {
        CustomTextField(
            variant: .count(max: max),
            placeholder: placeholder,
            onTapField: nil
        )
    }

    static func short(
        placeholder: String
    ) -> CustomTextField {
        CustomTextField(
            variant: .short,
            placeholder: placeholder,
            onTapField: nil
        )
    }

    static func shortNavigate(
        placeholder: String,
        onTapField: (() -> Void)? = nil
    ) -> CustomTextField {
        CustomTextField(
            variant: .short,
            placeholder: placeholder,
            isTapOnly: true,
            onTapField: onTapField
        )
    }
}
