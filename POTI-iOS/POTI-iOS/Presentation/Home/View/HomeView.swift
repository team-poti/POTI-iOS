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
    let floatingButton = FloatingButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        homeCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            
            $0.register(BannerCell.self)
            $0.register(GoodsCell.self)
            
            $0.registerFooter(BannerFooterCell.self)
            $0.registerHeader(GoodsHeaderCell.self)
        }
    }
    
    override func setUI() {
        addSubviews(homeCollectionView, floatingButton)
    }
    
    override func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(.dynamicH(114) + 16)
        }
    }
}
