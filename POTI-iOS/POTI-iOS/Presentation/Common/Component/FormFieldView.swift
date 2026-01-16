//
//  FormFieldView.swift
//  POTI-iOS
//

import UIKit

import SnapKit
import Then

final class FormFieldView: BaseView {

    // MARK: - Property

    var onTapField: (() -> Void)?
    var onTextChanged: ((String) -> Void)?
    var onSelectOption: ((String) -> Void)?

    private(set) var variant: FormFieldVariant = .short
    private var uiState: FormFieldUIState = .normal


    // MARK: - UI Components

    private let containerView = UIView()
    private let textField = UITextField()
    private let textView = UITextView()
    private let textViewPlaceholderLabel = UILabel()

    private let rightAccessoryContainer = UIView()
    private let rightIconView = UIImageView()
    private let countLabel = UILabel()

    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    private let dropdownListView = DropdownListView()
    private let arrowDownImage = UIImage(named: "icn-arrow-down-lg")
    private let arrowUpImage = UIImage(named: "icn-arrow-up-lg")

    private var textFieldTrailingToAccessory: Constraint?
    private var textFieldTrailingToSuperview: Constraint?
    private var textViewTrailingToAccessory: Constraint?
    private var textViewTrailingToSuperview: Constraint?

    private var dropdownListHeightConstraint: Constraint?
    private var errorStackHeightConstraint: Constraint?

    private var bottomToContainer: Constraint?
    private var bottomToDropdown: Constraint?
    private var bottomToError: Constraint?

    private var isDropdownVisible: Bool = false


    // MARK: - Life Cycle

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
        clipsToBounds = false
        containerView.clipsToBounds = false

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

        dropdownListView.do {
            $0.isHidden = true
            $0.alpha = 0
        }

        dropdownListView.onSelectItem = { [weak self] _, value in
            guard let self else { return }
            self.setText(value)
            self.onSelectOption?(value)
            self.hideOptions(animated: false)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        containerView.addGestureRecognizer(tap)
    }

    override func setUI() {
        addSubviews(containerView, dropdownListView, errorStackView)

        containerView.addSubviews(textField, textView)
        textView.addSubview(textViewPlaceholderLabel)
        containerView.addSubview(rightAccessoryContainer)

        rightAccessoryContainer.addSubviews(rightIconView, countLabel)

        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(52)
            bottomToContainer = $0.bottom.equalToSuperview().constraint
        }

        dropdownListView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            dropdownListHeightConstraint = $0.height.equalTo(0).constraint
            bottomToDropdown = $0.bottom.equalToSuperview().constraint
        }

        bottomToDropdown?.deactivate()

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

    func configure(
        variant: FormFieldVariant,
        placeholder: String? = nil
    ) {
        self.variant = variant

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

        applyVariant()
        apply(state: uiState)
    }

    func apply(state: FormFieldUIState) {
        uiState = state

        switch state {
        case .normal:
            containerView.layer.borderColor = UIColor.gray300.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true
            errorStackHeightConstraint?.activate()
            bottomToError?.deactivate()
            bottomToDropdown?.deactivate()
            bottomToContainer?.activate()

        case .focused:
            containerView.layer.borderColor = UIColor.potiBlack.cgColor
            errorLabel.text = nil
            errorStackView.isHidden = true
            errorStackHeightConstraint?.activate()
            bottomToError?.deactivate()
            bottomToDropdown?.deactivate()
            bottomToContainer?.activate()

        case .error(let message):
            containerView.layer.borderColor = UIColor.sementicRed.cgColor
            errorLabel.text = message
            errorStackView.isHidden = false
            errorStackHeightConstraint?.deactivate()
            bottomToDropdown?.deactivate()
            bottomToContainer?.deactivate()
            bottomToError?.activate()
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

    func setOptions(_ options: [String], maxVisibleRows: Int = 3) {
        dropdownListView.maxVisibleRows = maxVisibleRows
        dropdownListView.setItems(options)

        if options.isEmpty {
            hideOptions(animated: false)
        }
    }

    func showOptions(animated: Bool = true) {
        guard dropdownListView.itemsCount > 0 else { return }
        isDropdownVisible = true
        dropdownListView.isHidden = false
        dropdownListHeightConstraint?.update(offset: dropdownListView.requiredHeight)

        if case .dropdown = variant {
            rightIconView.image = arrowUpImage
        }

        bottomToError?.deactivate()
        bottomToContainer?.deactivate()
        bottomToDropdown?.activate()

        dropdownListView.alpha = 1
        (superview ?? self).layoutIfNeeded()
    }

    func hideOptions(animated: Bool = true) {
        guard isDropdownVisible else {
            dropdownListView.isHidden = true
            dropdownListView.alpha = 0
            dropdownListHeightConstraint?.update(offset: 0)

            if case .dropdown = variant {
                rightIconView.image = arrowDownImage
            }

            bottomToDropdown?.deactivate()
            bottomToError?.deactivate()
            bottomToContainer?.activate()

            (superview ?? self).layoutIfNeeded()
            return
        }

        isDropdownVisible = false

        dropdownListView.alpha = 0
        dropdownListHeightConstraint?.update(offset: 0)
        dropdownListView.isHidden = true

        if case .dropdown = variant {
            rightIconView.image = arrowDownImage
        }

        bottomToDropdown?.deactivate()
        bottomToError?.deactivate()
        bottomToContainer?.activate()

        (superview ?? self).layoutIfNeeded()
    }

    func toggleOptions() {
        isDropdownVisible ? hideOptions(animated: false) : showOptions(animated: false)
    }

    func updateCount(current: Int, max: Int) {
        countLabel.text = "\(current)/\(max)"
    }

    func updateTextViewPlaceholderVisibility() {
        updateTextViewPlaceholderIfNeeded()
    }


    // MARK: - Custom Method

    private func applyVariant() {
        rightIconView.isHidden = true
        countLabel.isHidden = true
        rightAccessoryContainer.isHidden = true

        switch variant {
        case .dropdown, .search(mode: .navigate):
            textField.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = false

        default:
            textField.isUserInteractionEnabled = true
            textView.isUserInteractionEnabled = true
        }

        switch variant {
        case .long:
            textField.isHidden = true
            textView.isHidden = false

            containerView.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(160)
            }

        default:
            textField.isHidden = false
            textView.isHidden = true

            containerView.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(48)
            }
        }

        switch variant {
        case .dropdown:
            rightIconView.isHidden = false
            rightIconView.image = arrowDownImage

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

        hideOptions(animated: false)
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


    // MARK: - Action Method

    @objc private func textFieldEditingChanged() {
        updateCountIfNeeded()
        onTextChanged?(getText())
    }

    @objc private func didTapField() {
        switch variant {
        case .dropdown:
            if dropdownListView.itemsCount > 0 {
                toggleOptions()
            } else {
                onTapField?()
            }

        case .search(mode: .navigate):
            onTapField?()

        default:
            break
        }
    }
}
