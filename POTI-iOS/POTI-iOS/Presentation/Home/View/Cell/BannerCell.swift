//
//  BannerCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class BannerCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private var bannerImageView = UIImageView()
    
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
        self.backgroundColor = .clear
        
        bannerImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        addSubviews(bannerImageView)
    }
    
    private func setLayout() {
        bannerImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(196)
            $0.top.equalToSuperview()
        }
    }
}

// MARK: - Extension

extension BannerCell {
    func configure(banner: BannerModel) {
        bannerImageView.kf.setImage(with: URL(string: banner.imageUrl))
    }
}
