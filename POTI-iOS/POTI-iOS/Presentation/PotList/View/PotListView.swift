//
//  PotListView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class PotListView: BaseView {
    
    // MARK: - UI Components
    
    lazy var potListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewFlowLayout()
    )
    let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        potListCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(PotListCell.self)
            $0.registerHeader(PotListHeaderCell.self)
        }
    }
    
    override func setUI() {
        addSubviews(potListCollectionView, floatingButton)
    }
    
    override func setLayout() {
        potListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(60)
        }
    }
}

// MARK: - Extension

private extension PotListView {
    func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 32
        layout.itemSize = CGSize(width: itemWidth, height: 181)
        
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 48)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 88, right: 16)
        
        return layout
    }
}
