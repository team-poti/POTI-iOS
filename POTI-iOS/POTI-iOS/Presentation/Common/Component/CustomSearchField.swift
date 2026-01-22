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
    private var searchListHeightConstraint: Constraint?
    private var isSelectingItem: Bool = false

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
            $0.image = .icnSearch
        }

        rightAccessoryContainer.do {
            $0.backgroundColor = .clear
        }

        searchListView.do {
            $0.isHidden = false
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: -6)
            $0.onSelectItem = { [weak self] index, value in
                guard let self else { return }
                self.isSelectingItem = true
                self.setText(value)
                self.onSelectItem?(index, value)
                self.hideList(animated: true)
                self.textField.resignFirstResponder()
                self.isSelectingItem = false
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
            $0.image = .icnNotice
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
        addSubviews(rootStackView, errorStackView)

        rootStackView.addArrangedSubviews(containerView, searchListView)
        containerView.addSubviews(textField, rightAccessoryContainer)
        rightAccessoryContainer.addSubview(rightIconView)
        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
        addTarget()
    }

    override func setLayout() {
        rootStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(52)
        }

        searchListView.snp.makeConstraints {
            searchListHeightConstraint = $0.height.equalTo(0).priority(999).constraint
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
            hideList(animated: true)
            return
        }

        let targetHeight = searchListView.requiredHeight
        searchListHeightConstraint?.update(offset: targetHeight)

        if isListVisible {
            UIView.performWithoutAnimation {
                self.superview?.layoutIfNeeded()
            }
        } else {
            showList(animated: true)
        }
    }

    func clearItems() {
        searchListView.clear()
        hideList(animated: true)
    }

    func showList(animated: Bool = true) {
        guard !isListVisible else { return }

        isListVisible = true
        searchListView.isUserInteractionEnabled = true

        let targetHeight = searchListView.requiredHeight

        searchListView.alpha = 0
        searchListView.transform = CGAffineTransform(translationX: 0, y: -6)

        searchListHeightConstraint?.update(offset: targetHeight)

        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseOut],
                animations: {
                    self.searchListView.alpha = 1
                    self.searchListView.transform = .identity
                    self.superview?.layoutIfNeeded()
                }
            )
        } else {
            searchListView.alpha = 1
            searchListView.transform = .identity
            superview?.layoutIfNeeded()
        }
    }

    func hideList(animated: Bool = true) {
        guard isListVisible else { return }

        isListVisible = false

        searchListHeightConstraint?.update(offset: 0)

        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseIn],
                animations: {
                    self.searchListView.alpha = 0
                    self.searchListView.transform = CGAffineTransform(translationX: 0, y: -6)
                    self.superview?.layoutIfNeeded()
                }
            )
        } else {
            searchListView.alpha = 0
            searchListView.transform = CGAffineTransform(translationX: 0, y: -6)
            superview?.layoutIfNeeded()
        }
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

    private func addTarget() {
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
            showList(animated: true)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        apply(state: .normal)
        guard !isSelectingItem else { return }
        hideList(animated: true)
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
