//
//  GoodsListView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class GoodsListView: BaseView {
    
    // MARK: - UI Components
    
    lazy var goodsListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: GoodsListCompositionalLayoutFactory.createLayout()
    )
    private let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        // TODO: - 네비바 컴포넌트 추가하기
        
        goodsListCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(GoodsListCell.self, forCellWithReuseIdentifier: "GoodsListCell")
            $0.register(
                GoodsListHeaderCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "GoodsListHeaderCell"
            )
        }
    }
    
    override func setUI() {
        addSubviews(goodsListCollectionView, floatingButton)
    }
    
    override func setLayout() {
        goodsListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}

