//
//  BannerCarouselCell.swift
//  POTI-iOS
//
//  Created by mandoo on 5/27/26.
//

import UIKit

import SnapKit

final class BannerCarouselCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let carouselView = BannerCarouselView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setUI() {
        contentView.addSubview(carouselView)
    }
    
    private func setLayout() {
        carouselView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Configure

extension BannerCarouselCell {
    func configure(banners: [BannerModel]) {
        carouselView.configure(banners: banners)
    }
}
