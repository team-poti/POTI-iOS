//
//  FeedsView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class FeedsView: BaseView {
    
    // MARK: - UI Components
    
    lazy var feedsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        feedsCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(FeedsCell.self)
            $0.registerHeader(FeedsHeaderCell.self)
        }
    }
    
    override func setUI() {
        addSubviews(feedsCollectionView, floatingButton)
    }
    
    override func setLayout() {
        feedsCollectionView.snp.makeConstraints {
            $0.edges.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(60)
        }
    }
    
    // MARK: - Method
    
    func updateLayout(sectionType: HomeSection) {
        let layout = makeCollectionViewFlowLayout(for: sectionType)
        feedsCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}

private extension FeedsView {
    func makeCollectionViewFlowLayout(for sectionType: HomeSection) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 32
        layout.itemSize = CGSize(width: itemWidth, height: 221)
        
        if sectionType != .otherGroup {
            layout.headerReferenceSize = CGSize(width: screenWidth, height: 48)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 88, right: 16)
        } else {
            layout.headerReferenceSize = .zero
            layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 88, right: 16)
        }
        
        return layout
    }
}
