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
    
    private var bannerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private var shadowImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        
        let angle = CGFloat(-4.26 * Double.pi / 180)
        $0.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private var shadowLayerView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    func setStyle() {
        contentView.addSubviews(shadowImageView, bannerImageView)
        shadowImageView.addSubview(shadowLayerView)
    }
    
    func setLayout() {
        shadowImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        bannerImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        shadowLayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Extension

extension BannerCell {
    func configure(with entity: BannerEntity) {
        bannerImageView.kf.setImage(with: URL(string: entity.imageURL ?? ""))
        shadowImageView.kf.setImage(with: URL(string: entity.imageURL ?? ""))
    }
}
