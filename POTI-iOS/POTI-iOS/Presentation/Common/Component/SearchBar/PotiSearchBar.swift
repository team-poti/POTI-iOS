//
//  PotiSearchBar.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import UIKit

import Combine
import SnapKit
import Then

enum PotiSearchBarAppearance: Equatable {
    case outlined
    case filled
}

final class PotiSearchBar: BaseView {

    // MARK: - Properties

    var onBeginEditing: ((UIView) -> Void)?
    var onEndEditing: (() -> Void)?
    var onSubmit: ((String) -> Void)?
    var onClear: (() -> Void)?

    var text: String {
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
            updateAccessoryImage()
        }
    }

    var textPublisher: AnyPublisher<String, Never> {
        textSubject.removeDuplicates().eraseToAnyPublisher()
    }

    private let appearance: PotiSearchBarAppearance
    private let showsSearchIcon: Bool
    private let textSubject = CurrentValueSubject<String, Never>("")
    private var validationState: TextFieldValidationState = .normal
    private var isInputFocused = false

    // MARK: - UI Components

    private let inputContainer = TextInputContainerView()
    private let textField = UITextField()
    private let accessoryButton = UIButton()
    private var trailingToSearchAccessory: Constraint?
    private var trailingToClearAccessory: Constraint?
    private var trailingToSuperview: Constraint?

    // MARK: - Initializer

    init(placeholder: String? = nil, appearance: PotiSearchBarAppearance = .outlined, showsSearchIcon: Bool = true) {
        self.appearance = appearance
        self.showsSearchIcon = showsSearchIcon
        super.init(frame: .zero)
        configurePlaceholder(placeholder)
        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .search
        }

        accessoryButton.do {
            $0.imageView?.contentMode = .scaleAspectFit
        }

        if appearance == .filled {
            inputContainer.setAppearance(backgroundColor: .gray100, borderWidth: 0)
        }
        
        updateAccessoryImage()
    }

    override func setUI() {
        addSubview(inputContainer)
        inputContainer.contentView.addSubviews(textField, accessoryButton)
    }

    override func setLayout() {
        inputContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        accessoryButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(appearance == .filled ? 4 : 12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(appearance == .filled ? 48 : 24)
        }
        
        textField.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(12)
            trailingToSearchAccessory = $0.trailing.equalTo(accessoryButton.snp.leading).offset(-12).constraint
            trailingToClearAccessory = $0.trailing.equalTo(accessoryButton.snp.leading).constraint
            trailingToSuperview = $0.trailing.equalToSuperview().inset(16).constraint
        }
        updateAccessoryLayout()
    }
    
    private func addTarget() {
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        accessoryButton.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
    }

    // MARK: - Public Methods

    func setValidationState(_ state: TextFieldValidationState) {
        validationState = state
        render()
    }

    func focus() {
        textField.becomeFirstResponder()
    }

    func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    // MARK: - Private Methods

    private func configurePlaceholder(_ placeholder: String?) {
        guard let placeholder else { return }
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: PotiFontManager.body16m.font, .foregroundColor: UIColor.gray700])
    }

    private func render() {
        guard appearance == .outlined else { return }
        inputContainer.render(isFocused: isInputFocused, validationState: validationState)
    }

    private func updateAccessoryLayout() {
        let isAccessoryHidden = appearance == .outlined && !showsSearchIcon
        accessoryButton.isHidden = isAccessoryHidden
        
        if isAccessoryHidden {
            trailingToSearchAccessory?.deactivate()
            trailingToClearAccessory?.deactivate()
            trailingToSuperview?.activate()
        } else if appearance == .filled && !text.isEmpty {
            trailingToSuperview?.deactivate()
            trailingToSearchAccessory?.deactivate()
            trailingToClearAccessory?.activate()
        } else {
            trailingToSuperview?.deactivate()
            trailingToClearAccessory?.deactivate()
            trailingToSearchAccessory?.activate()
        }
    }

    private func updateAccessoryImage() {
        let image: UIImage?
        let imageSize: CGSize
        let showsClearButton = appearance == .filled && !text.isEmpty
        
        switch appearance {
        case .outlined:
            image = showsSearchIcon ? .icnSearch : nil
            imageSize = CGSize(width: 24, height: 24)
        case .filled:
            image = text.isEmpty ? .icnSearch : .icnX
            imageSize = text.isEmpty ? CGSize(width: 24, height: 24) : CGSize(width: 48, height: 48)
        }
        
        accessoryButton.setImage(image?.resized(to: imageSize).withRenderingMode(.alwaysTemplate), for: .normal)
        accessoryButton.tintColor = showsClearButton ? .potiBlack : appearance == .filled ? .gray500 : .gray700
        accessoryButton.isUserInteractionEnabled = showsClearButton
        updateAccessoryLayout()
    }

    // MARK: - Action

    @objc private func editingChanged() {
        guard textField.markedTextRange == nil else { return }
        updateAccessoryImage()
        textSubject.send(text)
    }

    @objc private func accessoryButtonTapped() {
        guard appearance == .filled, !text.isEmpty else { return }
        text = ""
        textSubject.send("")
        onClear?()
    }
}

// MARK: - UITextFieldDelegate

extension PotiSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSubmit?(text)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isInputFocused = true
        render()
        onBeginEditing?(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isInputFocused = false
        render()
        onEndEditing?()
    }
}
