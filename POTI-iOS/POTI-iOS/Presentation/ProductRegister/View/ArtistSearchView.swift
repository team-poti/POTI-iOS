//
//  ArtistSearchView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class ArtistSearchView: BaseView, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("아티스트 검색")
    }
    
    // MARK: - Property

    var onChangeQuery: ((String) -> Void)?

    var onTapDone: (() -> Void)?

    // MARK: - UI Components

    private let searchBoxView = UIView()
    private let searchTextField = UITextField()
    private let searchIconView = UIImageView()
    private let doneButton = PotiBottomButton()

    // MARK: - Life Cycle

    // MARK: - Custom Method

    override func setStyle() {
        backgroundColor = .potiWhite
        
        searchTextField.do {
            $0.placeholder = "분철할 그룹을 검색해보세요"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }

        doneButton.do {
            $0.text = "완료"
            $0.color = .deactiveMain
            $0.size = .large
            $0.isDisabled = true
        }
    }

    override func setUI() {
        addSubviews(searchBoxView, searchTextField, doneButton)

        searchTextField.addTarget(self, action: #selector(didChangeQuery), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }

    override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }

        doneButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }

    // MARK: - Action Method

    func setDoneEnabled(_ isEnabled: Bool) {
        doneButton.isDisabled = !isEnabled
        doneButton.color = isEnabled ? .primaryMain : .secondaryMain
    }

    func setQuery(_ text: String?) {
        searchTextField.text = text
    }

    func focusQuery() {
        searchTextField.becomeFirstResponder()
    }

    // MARK: - delegate Method

    @objc private func didChangeQuery() {
        onChangeQuery?(searchTextField.text ?? "")
        setDoneEnabled(!(searchTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    @objc private func didTapDoneButton() {
        onTapDone?()
    }
}

#Preview() {
    ArtistSearchView()
}
