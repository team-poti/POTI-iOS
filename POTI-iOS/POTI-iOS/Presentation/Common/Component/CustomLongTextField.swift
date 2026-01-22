//
//  CustomLongTextField.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class CustomLongTextField: BaseView {

    // MARK: - Property

    public var onBeginEditing: ((UITextView) -> Void)?

    private var uiState: TextFieldUIState = .normal

    // MARK: - UI Components

    private let containerView = UIView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()

    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    private var errorStackHeightConstraint: Constraint?
    private var bottomToContainer: Constraint?
    private var bottomToError: Constraint?

    // MARK: - Private Setup

    override func setStyle() {
        backgroundColor = .clear
        clipsToBounds = false

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }

        textView.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.delegate = self
        }

        placeholderLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray700
            $0.numberOfLines = 2
            $0.isHidden = true
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
            $0.image = UIImage(named: "icn-notice")
            $0.tintColor = .sementicRed
        }

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
        }
    }

    override func setUI() {
        addSubviews(containerView, errorStackView)

        containerView.addSubview(textView)
        textView.addSubview(placeholderLabel)

        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(160)
            bottomToContainer = $0.bottom.equalToSuperview().constraint
        }

        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }

        errorStackView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            bottomToError = $0.bottom.equalToSuperview().constraint
            errorStackHeightConstraint = $0.height.equalTo(0).priority(999).constraint
        }

        bottomToError?.deactivate()

        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }

    // MARK: - Custom Method

    func configure(placeholder: String? = nil) {
        placeholderLabel.text = placeholder
        placeholderLabel.isHidden = !(textView.text ?? "").isEmpty

        if placeholder != nil {
            placeholderLabel.font = PotiFontManager.body16m.font
            placeholderLabel.textColor = .gray700
        }
        apply(state: uiState)
    }

    func apply(state: TextFieldUIState) {
        uiState = state

        switch state {
        case .normal:
            containerView.layer.borderColor = UIColor.gray300.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true
            errorStackHeightConstraint?.activate()
            bottomToError?.deactivate()
            bottomToContainer?.activate()

        case .focused:
            containerView.layer.borderColor = UIColor.potiBlack.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true
            errorStackHeightConstraint?.activate()
            bottomToError?.deactivate()
            bottomToContainer?.activate()

        case .error(let message):
            containerView.layer.borderColor = UIColor.sementicRed.cgColor
            errorLabel.text = message
            errorStackView.isHidden = false
            errorStackHeightConstraint?.deactivate()
            bottomToContainer?.deactivate()
            bottomToError?.activate()
        }
    }

    func setText(_ text: String?) {
        textView.text = text ?? ""
        updatePlaceholderIfNeeded()
    }

    func getText() -> String {
        return textView.text ?? ""
    }

    // MARK: - Private Method

    private func updatePlaceholderIfNeeded() {
        placeholderLabel.isHidden = !(textView.text ?? "").isEmpty
    }
}

extension CustomLongTextField: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        apply(state: .focused)
        onBeginEditing?(textView)
        updatePlaceholderIfNeeded()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        apply(state: .normal)
        updatePlaceholderIfNeeded()
    }

    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderIfNeeded()
    }
}

extension CustomLongTextField {

    static func long(
        placeholder: String
    ) -> CustomLongTextField {
        let view = CustomLongTextField()
        view.configure(placeholder: placeholder)
        return view
    }
}
