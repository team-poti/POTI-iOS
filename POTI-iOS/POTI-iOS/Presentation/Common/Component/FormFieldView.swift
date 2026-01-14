//
//  FormFieldView.swift
//  POTI-iOS
//

import UIKit

import SnapKit
import Then

// MARK: - Types

enum FormFieldVariant {
    case dropdown
    case search(mode: SearchMode)
    case count(max: Int)
    case short
    case long(minHeight: CGFloat = 160)
}

enum SearchMode {
    case navigate     // 탭하면 검색화면
    case suggest      // 입력하면 드롭다운
}

enum FormFieldUIState: Equatable {
    case normal
    case focused
    case error(message: String)
}

// MARK: - View

final class FormFieldView: BaseView {

    // MARK: - Output

    /// 탭 액션 전달 (dropdown, search(navigate))
    var onTapField: (() -> Void)?

    /// 입력 텍스트 변경 전달 (search(suggest), count, short, long)
    var onTextChanged: ((String) -> Void)?

    // MARK: - State

    private var variant: FormFieldVariant = .short
    private var uiState: FormFieldUIState = .normal

    // MARK: - UI

    private let containerView = UIView()
    private let textField = UITextField()
    private let textView = UITextView()
    private let textViewPlaceholderLabel = UILabel()

    private let rightAccessoryContainer = UIView()
    private let rightIconView = UIImageView()
    private let countLabel = UILabel()

    private let errorLabel = UILabel()

    private var textFieldTrailingToAccessory: Constraint?
    private var textFieldTrailingToSuperview: Constraint?
    private var textViewTrailingToAccessory: Constraint?
    private var textViewTrailingToSuperview: Constraint?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Setup

    override func setStyle() {
        backgroundColor = .clear

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }

        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        textView.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.delegate = self
            $0.isHidden = true // 기본은 short라 textField 사용
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        textViewPlaceholderLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray700
            $0.numberOfLines = 1
            $0.isHidden = true
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

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
            $0.isHidden = true
        }

        // 필드 탭 제스처 (dropdown / search(navigate)용)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        containerView.addGestureRecognizer(tap)
    }

    override func setUI() {
        addSubview(containerView)
        addSubview(errorLabel)

        containerView.addSubview(textField)
        containerView.addSubview(textView)
        textView.addSubview(textViewPlaceholderLabel)
        containerView.addSubview(rightAccessoryContainer)

        rightAccessoryContainer.addSubview(rightIconView)
        rightAccessoryContainer.addSubview(countLabel)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
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

        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)

            textViewTrailingToAccessory = $0.trailing.equalTo(rightAccessoryContainer.snp.leading).offset(-8).constraint
            textViewTrailingToSuperview = $0.trailing.equalToSuperview().inset(16).constraint
        }

        textViewTrailingToSuperview?.deactivate()

        textViewPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }

        errorLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Public

    func configure(
        variant: FormFieldVariant,
        placeholder: String? = nil
    ) {
        self.variant = variant

        // placeholder
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

        textViewPlaceholderLabel.text = placeholder

        // variant 적용
        applyVariant()
        apply(state: uiState)
    }

    func apply(state: FormFieldUIState) {
        uiState = state

        switch state {
        case .normal:
            containerView.layer.borderColor = UIColor.gray300.cgColor
            errorLabel.isHidden = true

        case .focused:
            containerView.layer.borderColor = UIColor.potiBlack.cgColor
            errorLabel.isHidden = true

        case .error(let message):
            containerView.layer.borderColor = UIColor.sementicRed.cgColor
            errorLabel.text = message
            errorLabel.isHidden = false
        }
    }

    func setText(_ text: String?) {
        switch variant {
        case .long:
            textView.text = text ?? ""
            updateTextViewPlaceholderIfNeeded()
        default:
            textField.text = text
        }
        updateCountIfNeeded()
    }

    func getText() -> String {
        switch variant {
        case .long:
            return textView.text ?? ""
        default:
            return textField.text ?? ""
        }
    }

    // MARK: - Private

    private func applyVariant() {
        // 공통 초기화
        rightIconView.isHidden = true
        countLabel.isHidden = true
        rightAccessoryContainer.isHidden = true

        // 키보드/입력 사용 여부
        switch variant {
        case .dropdown, .search(mode: .navigate):
            // 키보드 X: editing 막고 탭 이벤트로 처리
            textField.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = false

        default:
            textField.isUserInteractionEnabled = true
            textView.isUserInteractionEnabled = true
        }

        // long이면 textView
        switch variant {
        case .long(let minHeight):
            textField.isHidden = true
            textView.isHidden = false

            containerView.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(minHeight)
            }

        default:
            textField.isHidden = false
            textView.isHidden = true

            containerView.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(48)
            }
        }

        // 오른쪽 accessory
        switch variant {
        case .dropdown:
            rightIconView.isHidden = false
            rightIconView.image = UIImage(named: "icn-arrow-down-lg")

        case .search:
            rightIconView.isHidden = false
            rightIconView.image = UIImage(named: "icn-search")

        case .count(let max):
            countLabel.isHidden = false
            countLabel.text = "0/\(max)"

        case .short, .long:
            break
        }

        let hasAccessory = (!rightIconView.isHidden) || (!countLabel.isHidden)

        if hasAccessory {
            rightAccessoryContainer.isHidden = false
            textFieldTrailingToSuperview?.deactivate()
            textViewTrailingToSuperview?.deactivate()
            textFieldTrailingToAccessory?.activate()
            textViewTrailingToAccessory?.activate()
        } else {
            rightAccessoryContainer.isHidden = true
            textFieldTrailingToAccessory?.deactivate()
            textViewTrailingToAccessory?.deactivate()
            textFieldTrailingToSuperview?.activate()
            textViewTrailingToSuperview?.activate()
        }

        updateCountIfNeeded()
        updateTextViewPlaceholderIfNeeded()
    }

    private func updateCountIfNeeded() {
        guard case .count(let max) = variant else { return }
        let count = getText().count
        countLabel.text = "\(count)/\(max)"
    }

    private func updateTextViewPlaceholderIfNeeded() {
        guard case .long = variant else {
            textViewPlaceholderLabel.isHidden = true
            return
        }

        textViewPlaceholderLabel.isHidden = !(textView.text ?? "").isEmpty
    }

    // MARK: - Action

    @objc private func textFieldEditingChanged() {
        updateCountIfNeeded()
        onTextChanged?(getText())
    }

    @objc private func didTapField() {
        switch variant {
        case .dropdown, .search(mode: .navigate):
            onTapField?()
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension FormFieldView: UITextFieldDelegate {

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

        // count(max): 최대 글자수 도달하면 입력 막기 + next 기준으로 카운트 즉시 반영
        if case .count(let max) = variant {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return true }
            let next = current.replacingCharacters(in: r, with: string)
            if next.count > max { return false }

            countLabel.text = "\(next.count)/\(max)"
            onTextChanged?(next)
            return true
        }

        return true
    }
}

// MARK: - UITextViewDelegate

extension FormFieldView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        apply(state: .focused)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        apply(state: .normal)
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {

        // count(max)가 long에 붙을 일은 없지만(요구사항상), 안전하게 막아둠
        if case .count(let max) = variant {
            let current = textView.text ?? ""
            guard let r = Range(range, in: current) else { return true }
            let next = current.replacingCharacters(in: r, with: text)
            if next.count > max { return false }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.updateCountIfNeeded()
            self.onTextChanged?(self.getText())
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        updateTextViewPlaceholderIfNeeded()
    }
}
