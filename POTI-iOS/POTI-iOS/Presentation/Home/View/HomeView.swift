//
//  HomeView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class HomeView: BaseView {
    
    // MARK: - Property
    
    var currentPageNumber = PassthroughSubject<Int, Never>()
    
    // MARK: - UI Components
    
    lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HomeLayoutFactory.createLayout(currentPageNumber: currentPageNumber)
    )
    private let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        // TODO: - 네비바 컴포넌트 추가하기
        
        homeCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
            $0.register(GoodsCell.self, forCellWithReuseIdentifier: "GoodsCell")
            
            $0.register(
                BannerFooterCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "BannerFooterCell"
            )
            $0.register(
                GoodsHeaderCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "GoodsHeaderCell"
            )
        }
    }
    
    override func setUI() {
        addSubviews(homeCollectionView, floatingButton)
    }
    
    override func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(.dynamicH(114) + 16)
        }
    }
}
