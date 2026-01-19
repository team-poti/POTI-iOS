//
//  CustomSearchField.swift
//  POTI-iOS
//

import UIKit

import SnapKit
import Then

final class CustomSearchField: BaseView {

    // MARK: - Property

    var onQueryChanged: ((String) -> Void)?
    var onSelectItem: ((Int, String) -> Void)?

    private var isListVisible: Bool = false
    private var textFieldTrailingConstraint: Constraint?

    // MARK: - UI Components

    private let rootStackView = UIStackView()

    private let containerView = UIView()
    private let textField = UITextField()

    private let rightAccessoryContainer = UIView()
    private let rightIconView = UIImageView()

    private let searchListView = SearchListView()
    
    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
        bindInternalHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setting

    override func setStyle() {
        backgroundColor = .clear
        clipsToBounds = false

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }

        rootStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fill
        }

        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .search
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        rightIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray700
            $0.image = UIImage(named: "icn-search")
        }

        rightAccessoryContainer.do {
            $0.backgroundColor = .clear
        }

        searchListView.do {
            $0.isHidden = true
            $0.onSelectItem = { [weak self] index, value in
                guard let self else { return }
                self.setText(value)
                self.hideList()
                self.onSelectItem?(index, value)
            }
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
            $0.image = UIImage(named: "icn-notice")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .sementicRed
        }

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
        }
        apply(state: .normal)
    }

    override func setUI() {
        addSubview(rootStackView)

        rootStackView.addArrangedSubviews(containerView, searchListView)
        containerView.addSubviews(textField, rightAccessoryContainer)
        rightAccessoryContainer.addSubview(rightIconView)
        
        addSubview(errorStackView)
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
            $0.size.equalTo(24)
        }

        rightIconView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            textFieldTrailingConstraint = $0.trailing.equalTo(rightAccessoryContainer.snp.leading).offset(-8).constraint
        }
        
        errorStackView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(containerView)
        }

        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }

    // MARK: - Custom Method

    func configure(
        placeholder: String? = nil,
        maxVisibleRows: Int = 3,
        showsRightAccessory: Bool = true
    ) {
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

        searchListView.maxVisibleRows = maxVisibleRows

        rightAccessoryContainer.isHidden = !showsRightAccessory

        textFieldTrailingConstraint?.deactivate()
        textField.snp.makeConstraints {
            if showsRightAccessory {
                textFieldTrailingConstraint = $0.trailing.equalTo(rightAccessoryContainer.snp.leading).offset(-8).constraint
            } else {
                textFieldTrailingConstraint = $0.trailing.equalToSuperview().inset(16).constraint
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    func apply(state: TextFieldUIState) {

        switch state {
        case .normal:
            containerView.layer.borderColor = UIColor.gray300.cgColor

        case .focused:
            containerView.layer.borderColor = UIColor.potiBlack.cgColor

        case .error(_):
            containerView.layer.borderColor = UIColor.sementicRed.cgColor
        }
    }

    func setText(_ text: String?) {
        textField.text = text
    }

    func getText() -> String {
        textField.text ?? ""
    }

    func setItems(_ items: [String]) {
        searchListView.setItems(items)

        if items.isEmpty {
            hideList()
        } else {
            showList()
        }
    }

    func clearItems() {
        searchListView.clear()
        hideList()
    }

    func showList() {
        guard !isListVisible else { return }

        isListVisible = true
        searchListView.isHidden = false
        searchListView.invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    func hideList() {
        guard isListVisible else { return }

        isListVisible = false
        searchListView.isHidden = true
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorStackView.isHidden = false
        apply(state: .error(message))
    }

    func hideError() {
        errorStackView.isHidden = true
        apply(state: .normal)
    }

    // MARK: - Private Method

    private func bindInternalHandlers() {
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }


    // MARK: - Action Method

    @objc private func textFieldEditingChanged() {
        let query = getText()
        onQueryChanged?(query)
    }
}

// MARK: - delegate Method

extension CustomSearchField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        apply(state: .focused)

        if searchListView.itemsCount > 0 {
            showList()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        apply(state: .normal)
        hideList()
    }
}

extension CustomSearchField {

    static func suggest(
        placeholder: String,
        maxVisibleRows: Int = 3,
        showsRightAccessory: Bool = true,
        onQueryChanged: ((String) -> Void)? = nil,
        onSelect: ((Int, String) -> Void)? = nil
    ) -> CustomSearchField {
        let view = CustomSearchField()
        view.configure(
            placeholder: placeholder,
            maxVisibleRows: maxVisibleRows,
            showsRightAccessory: showsRightAccessory
        )
        view.onQueryChanged = onQueryChanged
        view.onSelectItem = onSelect
        return view
    }
}
