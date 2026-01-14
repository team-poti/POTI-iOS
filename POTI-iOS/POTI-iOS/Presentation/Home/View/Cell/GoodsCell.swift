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
    
    private let backgroundGrayView = UIView()
    private var imageView = UIImageView()
    private var popularTagView = TagView(type: .secondarySmall, tagText: "인기")
    private var artistNameLabel = UILabel()
    private var productNameLabel = UILabel()
    private var potTagView = TagView(type: .primaryWhiteSmall, tagText: "")
    
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
            backgroundGrayView.do {
                $0.backgroundColor = .gray100
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 20
                $0.layer.borderColor = UIColor.gray300.cgColor
                $0.layer.borderWidth = 1
            }
        
            imageView.do {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 20
                $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        
            artistNameLabel.do {
                $0.font = PotiFontManager.caption12m.font
                $0.textColor = .gray800
            }
        
            productNameLabel.do {
                $0.font = PotiFontManager.body14m.font
                $0.textColor = .potiBlack
            }
    }
    
    private func setUI() {
        contentView.addSubview(backgroundGrayView)
        backgroundGrayView.addSubviews(imageView, popularTagView, artistNameLabel, productNameLabel, potTagView)
    }
    
    private func setLayout() {
        backgroundGrayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(backgroundGrayView).inset(1)
            $0.height.equalTo(128)
        }
        
        popularTagView.snp.makeConstraints {
            $0.top.leading.equalTo(backgroundGrayView).inset(12)
            $0.bottom.equalTo(imageView.snp.bottom).inset(93)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.leading.equalTo(backgroundGrayView.snp.leading).inset(12)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(artistNameLabel)
        }
        
        potTagView.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(backgroundGrayView).inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Extension

extension GoodsCell {
    func configure(goods: Goods) {
        imageView.kf.setImage(with: URL(string: goods.imageURL ?? ""))
        artistNameLabel.text = goods.artistName
        productNameLabel.text = goods.productName
        potTagView.setTagText("팟 \(goods.numberOfPot)개")
    }
}
