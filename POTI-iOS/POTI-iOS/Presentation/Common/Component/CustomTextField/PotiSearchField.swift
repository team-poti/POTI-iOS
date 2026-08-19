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

final class PotiSearchField<Item>: BaseView {

    // MARK: - Properties

    var onSelectItem: ((Item) -> Void)?
    var onBeginEditing: ((UIView) -> Void)?

    var text: String {
        get { searchBar.text }
        set { searchBar.text = newValue }
    }

    var textPublisher: AnyPublisher<String, Never> {
        searchBar.textPublisher
    }

    private var isInputFocused = false
    private var isListVisible = false
    private let titleProvider: (Item) -> String

    private let rootStackView = UIStackView()
    private let searchBar: PotiSearchBar
    private let searchListView: SearchListView<Item>

    // MARK: - Initializers

    init(placeholder: String? = nil, maxVisibleRows: Int = 3, showsSearchIcon: Bool = true, titleProvider: @escaping (Item) -> String) {
        self.titleProvider = titleProvider
        searchBar = PotiSearchBar(placeholder: placeholder, showsSearchIcon: showsSearchIcon)
        searchListView = SearchListView(titleProvider: titleProvider, maxVisibleRows: maxVisibleRows)
        super.init(frame: .zero)
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

        searchListView.do {
            $0.isHidden = true
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: -6)
            $0.onSelectItem = { [weak self] item in
                guard let self else { return }
                self.text = self.titleProvider(item)
                self.onSelectItem?(item)
                self.searchBar.dismissKeyboard()
            }
        }
    }

    override func setUI() {
        addSubview(rootStackView)
        rootStackView.addArrangedSubviews(searchBar, searchListView)
        searchBar.onBeginEditing = { [weak self] inputView in
            guard let self else { return }
            self.isInputFocused = true
            self.onBeginEditing?(inputView)
            self.updateListVisibility(animated: true)
        }
        searchBar.onEndEditing = { [weak self] in
            self?.isInputFocused = false
            self?.updateListVisibility(animated: true)
        }
    }

    override func setLayout() {
        rootStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Public Methods

    func updateSuggestions(_ items: [Item]) {
        searchListView.setItems(items)
        updateListVisibility(animated: true)
    }

    func setValidationState(_ state: TextFieldValidationState) {
        searchBar.setValidationState(state)
    }

    // MARK: - Private Methods

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

}
