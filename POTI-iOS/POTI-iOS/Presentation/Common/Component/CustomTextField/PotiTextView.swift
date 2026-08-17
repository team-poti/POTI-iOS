//
//  PotiTextView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotiTextView: BaseView {

    // MARK: - Properties

    var onBeginEditing: ((UIView) -> Void)?

    var text: String {
        get { textView.text ?? "" }
        set {
            textView.text = normalized(newValue)
            updatePlaceholder()
        }
    }

    var textPublisher: AnyPublisher<String, Never> {
        textSubject.removeDuplicates().eraseToAnyPublisher()
    }

    private var validationState: TextFieldValidationState = .normal
    private var isInputFocused = false
    private var maxLength: Int?
    private let textSubject = CurrentValueSubject<String, Never>("")

    private let inputContainer = TextInputContainerView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()

    // MARK: - Initializer

    convenience init(placeholder: String, maxLength: Int? = nil, minimumHeight: CGFloat = 160) {
        self.init(frame: .zero)
        self.maxLength = maxLength
        placeholderLabel.text = placeholder
        inputContainer.setMinimumHeight(minimumHeight)
        updatePlaceholder()
        render()
    }

    // MARK: - Custom Methods

    override func setStyle() {
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
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = false
        }
    }

    override func setUI() {
        addSubview(inputContainer)
        inputContainer.contentView.addSubviews(textView, placeholderLabel)
    }

    override func setLayout() {
        inputContainer.snp.makeConstraints { $0.edges.equalToSuperview() }
        textView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Public Method

    func setValidationState(_ state: TextFieldValidationState) {
        validationState = state
        render()
    }

    // MARK: - Private Methods

    private func normalized(_ value: String) -> String {
        guard let maxLength else { return value }
        return String(value.prefix(maxLength))
    }

    private func updatePlaceholder() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    private func render() {
        inputContainer.render(isFocused: isInputFocused, validationState: validationState)
    }
}

// MARK: - UITextViewDelegate

extension PotiTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        isInputFocused = true
        render()
        onBeginEditing?(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        isInputFocused = false
        render()
    }

    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {
            updatePlaceholder()
            return
        }
        let value = normalized(textView.text ?? "")
        if textView.text != value { textView.text = value }
        updatePlaceholder()
        textSubject.send(value)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let maxLength, textView.markedTextRange == nil else { return true }
        let current = textView.text ?? ""
        guard let range = Range(range, in: current) else { return true }
        return current.replacingCharacters(in: range, with: text).count <= maxLength
    }
}
