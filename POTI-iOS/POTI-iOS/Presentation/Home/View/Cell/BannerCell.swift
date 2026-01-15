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
    private var shadowImageView = UIImageView()
    private var shadowLayerView = UIView()
    
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
        bannerImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        shadowImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            
            let angle = CGFloat(-4.26 * Double.pi / 180)
            $0.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        shadowLayerView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }
    
    private func setUI() {
        contentView.addSubviews(shadowImageView, bannerImageView)
        shadowImageView.addSubview(shadowLayerView)
    }
    
    private func setLayout() {
        shadowImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(196)
        }
        
        bannerImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(196)
        }
        
        shadowLayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Extension

extension BannerCell {
    func configure(banner: BannerModel) {
        bannerImageView.kf.setImage(with: URL(string: banner.imageUrl))
        shadowImageView.kf.setImage(with: URL(string: banner.imageUrl))
    }
}
