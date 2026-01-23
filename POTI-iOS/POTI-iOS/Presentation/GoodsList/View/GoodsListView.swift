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
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        goodsListCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(GoodsListCell.self)
            $0.registerHeader(GoodsListHeaderCell.self)
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
    
    // MARK: - Method
    
    func updateLayout(sectionType: HomeSection) {
        let layout = GoodsListLayoutFactory.createLayout(sectionType: sectionType)
        goodsListCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}

