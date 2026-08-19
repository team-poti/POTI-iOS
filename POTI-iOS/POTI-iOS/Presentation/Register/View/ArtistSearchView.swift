//
//  ArtistSearchView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ArtistSearchView: BaseView {
    
    // MARK: - Properties
    
    var queryPublisher: AnyPublisher<String, Never> {
        searchField.textPublisher
    }
    var onSelectArtist: ((ArtistSearchResultEntity) -> Void)?
    var onTapConfirm: (() -> Void)?
    
    // MARK: - UI Components
    
    private let searchField = PotiSearchField<ArtistSearchResultEntity>(placeholder: "분철할 그룹을 검색해보세요", maxVisibleRows: 3, showsSearchIcon: true, titleProvider: { $0.name })
    private let searchStatusLabel = UILabel()
    private let confirmButton = PotiBottomButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .potiWhite
        
        confirmButton.do {
            $0.text = "완료"
            $0.color = .deactiveMain
            $0.isDisabled = true
        }
        
        searchStatusLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(searchField, searchStatusLabel, confirmButton)
        searchField.onSelectItem = { [weak self] in self?.onSelectArtist?($0) }
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func setLayout() {
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        searchStatusLabel.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
    
    // MARK: - Public Method
    
    func render(_ state: ArtistSearchViewModel.State) {
        searchField.updateSuggestions(state.artists)
        confirmButton.isDisabled = !state.isDoneEnabled
        confirmButton.color = state.isDoneEnabled ? .secondaryMain : .deactiveMain
        
        switch state.phase {
        case .idle, .loading, .results:
            searchStatusLabel.isHidden = true
        case .empty:
            searchStatusLabel.setText("검색 결과가 없어요\n다른 키워드로 다시 검색해보세요", lineSpacing: 4, alignment: .center)
            searchStatusLabel.isHidden = false
        case .error:
            searchStatusLabel.setText("검색 중 문제가 발생했어요\n잠시 후 다시 시도해주세요", lineSpacing: 4, alignment: .center)
            searchStatusLabel.isHidden = false
        }
    }
    
    // MARK: - Action
    
    @objc private func confirmButtonTapped() {
        onTapConfirm?()
    }
}
