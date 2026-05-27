//
//  BannerCell.swift
//  POTI-iOS
//
//  Created by mandoo on 5/27/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class BannerCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let bannerImageView = UIImageView()
    
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        bannerImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        contentView.addSubview(bannerImageView)
    }
    
    private func setLayout() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Configure

extension BannerCell {
    func configure(banner: BannerModel) {
        guard let url = URL(string: banner.imageUrl) else { return }
        bannerImageView.kf.setImage(with: url)
    }
}
