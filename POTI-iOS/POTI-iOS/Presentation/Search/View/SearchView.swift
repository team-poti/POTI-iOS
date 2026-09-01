//
//  SearchView.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class SearchView: BaseView {
    
    // MARK: - Properties
    
    var onTapBack: (() -> Void)?
    var onSubmitSearch: ((String) -> Void)?
    var queryPublisher: AnyPublisher<String, Never> {
        searchBar.textPublisher
    }
    
    // MARK: - UI Components
    
    let resultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: SearchView.makeCollectionViewLayout())
    private let searchHeaderView = UIView()
    private let backButton = UIButton()
    private let searchBar = PotiSearchBar(placeholder: "검색어를 입력하세요", appearance: .filled)
    private let statusLabel = UILabel()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .potiWhite
        
        backButton.do {
            $0.setImage(UIImage.icnArrowLeftLg.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .potiBlack
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        resultsCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
            $0.register(GoodsListCell.self)
        }
        
        statusLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(searchHeaderView, resultsCollectionView, statusLabel)
        searchHeaderView.addSubviews(backButton, searchBar)
    }
    
    override func setLayout() {
        searchHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.verticalEdges.trailing.equalToSuperview()
        }
        
        resultsCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(resultsCollectionView).offset(60)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        searchBar.onSubmit = { [weak self] in self?.onSubmitSearch?($0) }
    }
    
    // MARK: - Public Methods
    
    static func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 221)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 32, right: 16)
        return layout
    }
    
    func focusSearchBar() {
        searchBar.focus()
    }

    func dismissKeyboard() {
        searchBar.dismissKeyboard()
    }

    func render(_ state: SearchViewModel.State) {
        switch state.phase {
        case .idle, .loading, .results:
            statusLabel.isHidden = true
        case .empty:
            statusLabel.setLabel("검색 결과가 없어요\n다른 키워드로 다시 검색해보세요", font: .body14m, alignment: .center, color: .gray700)
            statusLabel.isHidden = false
        case .error:
            statusLabel.setLabel("검색 중 문제가 발생했어요\n잠시 후 다시 시도해주세요", font: .body14m, alignment: .center, color: .gray700)
            statusLabel.isHidden = false
        }
    }
    
    // MARK: - Action
    
    @objc private func backButtonTapped() {
        onTapBack?()
    }
}
