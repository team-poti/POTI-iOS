//
//  PotiSearchField.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotiSearchField<Item>: BaseView, UITextFieldDelegate {

    // MARK: - Properties

    var onSelectItem: ((Item) -> Void)?
    var onBeginEditing: ((UIView) -> Void)?

    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    var textPublisher: AnyPublisher<String, Never> {
        textSubject.removeDuplicates().eraseToAnyPublisher()
    }

    private var validationState: TextFieldValidationState = .normal
    private var isInputFocused = false
    private var isListVisible = false
    private let titleProvider: (Item) -> String
    private let textSubject = CurrentValueSubject<String, Never>("")

    private let rootStackView = UIStackView()
    private let inputContainer = TextInputContainerView()
    private let textField = UITextField()
    private let accessoryContainer = UIView()
    private let accessoryImageView = UIImageView()
    private let searchListView: SearchListView<Item>
    private var trailingToAccessory: Constraint?
    private var trailingToSuperview: Constraint?

    // MARK: - Initializers

    init(placeholder: String? = nil, maxVisibleRows: Int = 3, showsSearchIcon: Bool = true, titleProvider: @escaping (Item) -> String) {
        self.titleProvider = titleProvider
        searchListView = SearchListView(titleProvider: titleProvider, maxVisibleRows: maxVisibleRows)
        super.init(frame: .zero)
        configurePlaceholder(placeholder)
        accessoryContainer.isHidden = !showsSearchIcon
        if showsSearchIcon {
            trailingToSuperview?.deactivate()
            trailingToAccessory?.activate()
        } else {
            trailingToAccessory?.deactivate()
            trailingToSuperview?.activate()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        rootStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }

        textField.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .search
        }

        accessoryImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray700
            $0.image = .icnSearch
        }

        searchListView.do {
            $0.isHidden = true
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: -6)
            $0.onSelectItem = { [weak self] item in
                guard let self else { return }
                self.text = self.titleProvider(item)
                self.onSelectItem?(item)
                self.textField.resignFirstResponder()
            }
        }
    }

    override func setUI() {
        addSubview(rootStackView)
        rootStackView.addArrangedSubviews(inputContainer, searchListView)
        inputContainer.contentView.addSubviews(textField, accessoryContainer)
        accessoryContainer.addSubview(accessoryImageView)
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func setLayout() {
        rootStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        accessoryContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        accessoryImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            trailingToAccessory = $0.trailing.equalTo(accessoryContainer.snp.leading).offset(-8).constraint
            trailingToSuperview = $0.trailing.equalToSuperview().inset(16).constraint
        }
        trailingToSuperview?.deactivate()
    }

    // MARK: - Public Methods

    func updateSuggestions(_ items: [Item]) {
        searchListView.setItems(items)
        updateListVisibility(animated: true)
    }

    func setValidationState(_ state: TextFieldValidationState) {
        validationState = state
        render()
    }

    // MARK: - Private Methods

    private func configurePlaceholder(_ placeholder: String?) {
        guard let placeholder else { return }
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: PotiFontManager.body16m.font, .foregroundColor: UIColor.gray700])
    }

    private func render() {
        inputContainer.render(isFocused: isInputFocused, validationState: validationState)
    }

    private func updateListVisibility(animated: Bool) {
        setListVisible(isInputFocused && searchListView.itemsCount > 0, animated: animated)
    }

    private func setListVisible(_ visible: Bool, animated: Bool) {
        guard visible != isListVisible else { return }
        isListVisible = visible
        searchListView.layer.removeAllAnimations()

        if visible {
            searchListView.isHidden = false
            searchListView.alpha = 0
            searchListView.transform = CGAffineTransform(translationX: 0, y: -6)
        }

        let animations = {
            self.searchListView.alpha = visible ? 1 : 0
            self.searchListView.transform = visible ? .identity : CGAffineTransform(translationX: 0, y: -6)
        }
        let completion: (Bool) -> Void = { _ in
            if !self.isListVisible { self.searchListView.isHidden = true }
        }

        if animated {
            UIView.animate(withDuration: visible ? 0.3 : 0.2, animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }

    // MARK: - Action

    @objc private func editingChanged() {
        guard textField.markedTextRange == nil else { return }
        textSubject.send(text)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isInputFocused = true
        render()
        onBeginEditing?(textField)
        updateListVisibility(animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isInputFocused = false
        render()
        updateListVisibility(animated: true)
    }
}
