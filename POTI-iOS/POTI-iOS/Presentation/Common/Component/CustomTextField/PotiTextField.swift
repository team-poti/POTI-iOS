//
//  PotiTextField.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotiTextField: BaseView {

    // MARK: - Properties

    var onTap: (() -> Void)?
    var onBeginEditing: ((UIView) -> Void)?
    var showsFocusedBorderOnTap = true

    var text: String {
        get { textField.text ?? "" }
        set {
            textField.text = normalized(newValue)
            updateCount()
        }
    }

    var textPublisher: AnyPublisher<String, Never> {
        textSubject.removeDuplicates().eraseToAnyPublisher()
    }

    private(set) var variant: TextFieldVariant = .editable
    private var validationState: TextFieldValidationState = .normal
    private var isInputFocused = false
    private let textSubject = CurrentValueSubject<String, Never>("")

    private let inputContainer = TextInputContainerView()
    private let textField = UITextField()
    private let accessoryContainer = UIView()
    private let accessoryImageView = UIImageView()
    private let countLabel = UILabel()
    private let tapGesture = UITapGestureRecognizer()
    private var trailingToAccessory: Constraint?
    private var trailingToSuperview: Constraint?

    // MARK: - Initializer

    convenience init(variant: TextFieldVariant, placeholder: String? = nil, onTap: (() -> Void)? = nil) {
        self.init(frame: .zero)
        self.variant = variant
        self.onTap = onTap
        configurePlaceholder(placeholder)
        applyVariant()
    }

    // MARK: - Custom Methods

    override func setStyle() {
        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
        }

        accessoryImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray700
        }

        countLabel.do {
            $0.textAlignment = .right
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }

        tapGesture.addTarget(self, action: #selector(textFieldTapped))
        inputContainer.contentView.addGestureRecognizer(tapGesture)
    }

    override func setUI() {
        addSubview(inputContainer)
        inputContainer.contentView.addSubviews(textField, accessoryContainer)
        accessoryContainer.addSubviews(accessoryImageView, countLabel)
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func setLayout() {
        inputContainer.snp.makeConstraints { $0.edges.equalToSuperview() }

        accessoryContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(24)
            $0.width.equalTo(24).priority(750)
        }

        accessoryImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        countLabel.snp.makeConstraints { $0.edges.equalToSuperview() }

        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            trailingToAccessory = $0.trailing.equalTo(accessoryContainer.snp.leading).offset(-8).constraint
            trailingToSuperview = $0.trailing.equalToSuperview().inset(16).constraint
        }
        trailingToSuperview?.deactivate()
    }

    // MARK: - Public Methods

    func setValidationState(_ state: TextFieldValidationState) {
        validationState = state
        render()
    }

    func setFocused(_ focused: Bool) {
        isInputFocused = focused
        render()
    }

    // MARK: - Private Methods

    private func configurePlaceholder(_ placeholder: String?) {
        guard let placeholder else {
            textField.attributedPlaceholder = nil
            return
        }
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: PotiFontManager.body16m.font, .foregroundColor: UIColor.gray700])
    }

    private func applyVariant() {
        accessoryImageView.isHidden = true
        countLabel.isHidden = true

        switch variant {
        case .readOnly(let accessory):
            tapGesture.isEnabled = true
            textField.isUserInteractionEnabled = false
            if accessory == .search {
                accessoryImageView.image = .icnSearch
                accessoryImageView.isHidden = false
            }
        case .characterLimited(let maxLength):
            tapGesture.isEnabled = false
            textField.isUserInteractionEnabled = true
            countLabel.setLabel("0/\(maxLength)", font: .body14m, alignment: .right, color: .gray700)
            countLabel.isHidden = false
        case .editable:
            tapGesture.isEnabled = false
            textField.isUserInteractionEnabled = true
        }

        let hasAccessory = !accessoryImageView.isHidden || !countLabel.isHidden
        accessoryContainer.isHidden = !hasAccessory
        if hasAccessory {
            trailingToSuperview?.deactivate()
            trailingToAccessory?.activate()
        } else {
            trailingToAccessory?.deactivate()
            trailingToSuperview?.activate()
        }
        updateCount()
        render()
    }

    private func normalized(_ value: String) -> String {
        guard case .characterLimited(let maxLength) = variant else { return value }
        return String(value.prefix(maxLength))
    }

    private func updateCount() {
        guard case .characterLimited(let maxLength) = variant else { return }
        countLabel.setLabel("\(text.count)/\(maxLength)", font: .body14m, alignment: .right, color: .gray700)
    }

    private func render() {
        inputContainer.render(isFocused: isInputFocused, validationState: validationState)
    }

    // MARK: - Actions

    @objc private func editingChanged() {
        guard textField.markedTextRange == nil else { return }
        let value = normalized(textField.text ?? "")
        if textField.text != value { textField.text = value }
        updateCount()
        textSubject.send(value)
    }

    @objc private func textFieldTapped() {
        guard case .readOnly = variant else { return }
        if showsFocusedBorderOnTap { setFocused(true) }
        onTap?()
    }
}

// MARK: - UITextFieldDelegate

extension PotiTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFocused(true)
        onBeginEditing?(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setFocused(false)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard case .characterLimited(let maxLength) = variant, textField.markedTextRange == nil else { return true }
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return true }
        return current.replacingCharacters(in: range, with: string).count <= maxLength
    }
}

// MARK: - Factory Methods

extension PotiTextField {
    static func editable(placeholder: String) -> PotiTextField {
        PotiTextField(variant: .editable, placeholder: placeholder)
    }

    static func characterLimited(placeholder: String, maxLength: Int) -> PotiTextField {
        PotiTextField(variant: .characterLimited(maxLength: maxLength), placeholder: placeholder)
    }

    static func readOnly(placeholder: String, accessory: TextFieldAccessory = .none, onTap: (() -> Void)? = nil) -> PotiTextField {
        PotiTextField(variant: .readOnly(accessory: accessory), placeholder: placeholder, onTap: onTap)
    }
}
