//
//  GoodsCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class GoodsCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let backgroundGrayView = UIView().then {
        $0.backgroundColor = .gray100
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private var artistNameLabel = UILabel().then {
        $0.font = PotiFontManager.caption12m.font
        $0.textColor = .gray800
    }
    
    private var productNameLabel = UILabel().then {
        $0.font = PotiFontManager.body14m.font
        $0.textColor = .potiBlack
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
        contentView.addSubviews(backgroundGrayView, imageView, artistNameLabel, productNameLabel)
    }
    
    func setLayout() {
        backgroundGrayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(backgroundGrayView).inset(1)
            $0.height.equalTo(128)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.leading.equalTo(backgroundGrayView.snp.leading).inset(12)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(artistNameLabel)
        }
    }
}

// MARK: - Extension

extension GoodsCell {
    func configure(with entity: GoodsEntity) {
        imageView.kf.setImage(with: URL(string: entity.imageURL ?? ""))
        artistNameLabel.text = entity.artistName
        productNameLabel.text = entity.productName
    }
}

