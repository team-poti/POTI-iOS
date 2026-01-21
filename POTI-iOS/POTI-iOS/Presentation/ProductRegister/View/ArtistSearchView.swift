//
//  ArtistSearchView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class ArtistSearchView: BaseView {

    // MARK: - Property

    var onChangeQuery: ((String) -> Void)?
    var onSelectSuggestion: ((Int, String) -> Void)?
    var onTapDone: (() -> Void)?

    // MARK: - UI

    private let searchField = CustomSearchField()
    private let doneButton = PotiBottomButton()

    override func setStyle() {
        searchField.configure(
            placeholder: "아티스트를 검색해보세요",
            maxVisibleRows: 3,
            showsRightAccessory: true
        )
        
        doneButton.do {
            $0.text = "완료"
            $0.color = .deactiveMain
            $0.isDisabled = true
        }
    }

    override func setUI() {
        addSubviews(searchField, doneButton)

        searchField.onQueryChanged = { [weak self] text in
            self?.onChangeQuery?(text)
        }

        searchField.onSelectItem = { [weak self] index, value in
            self?.onSelectSuggestion?(index, value)
        }

        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
    }
    
    override func setLayout() {
        searchField.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        doneButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(4)
        }
    }

    func setSuggestions(_ items: [String]) {
        searchField.setItems(items)
    }

    func clearSuggestions() {
        searchField.clearItems()
    }
    
    func setSearchItems(_ items: [String]) {
        searchField.setItems(items)
    }

    func setDoneEnabled(_ isEnabled: Bool) {
        doneButton.isDisabled = !isEnabled
        doneButton.color = isEnabled ? .secondaryMain : .deactiveMain
    }

    @objc private func tapDone() {
        onTapDone?()
    }
}
