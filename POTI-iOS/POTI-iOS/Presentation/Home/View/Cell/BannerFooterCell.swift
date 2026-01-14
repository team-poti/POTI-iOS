//
//  BannerFooterCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class BannerFooterCell: UICollectionReusableView {
    
    // MARK: - Property
    
    private let bannerPageIndicator = UIPageControl()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        bannerPageIndicator.do {
            $0.currentPage = 0
            $0.numberOfPages = 3
            $0.pageIndicatorTintColor = .gray300
            $0.currentPageIndicatorTintColor = .poti200
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    private func setUI() {
        addSubview(bannerPageIndicator)
    }
    
    private func setLayout() {
        bannerPageIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    
    func updatePageControl(currentPage: Int) {
        bannerPageIndicator.currentPage = currentPage
    }
}
