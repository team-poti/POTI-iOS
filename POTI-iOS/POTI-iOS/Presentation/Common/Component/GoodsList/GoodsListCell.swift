//
//  GoodsListCell.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class GoodsListCell: UICollectionViewCell {

    // MARK: - UI Components

    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let popularTagView = TagView(type: .secondaryLarge)
    private let artistNameLabel = UILabel()
    private let productNameLabel = UILabel()
    private let potCountTagView = TagView(type: .primaryWhiteSmall)

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

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
        artistNameLabel.text = nil
        productNameLabel.text = nil
        popularTagView.isHidden = true
    }

    // MARK: - Custom Methods

    private func setStyle() {
        containerView.do {
            $0.backgroundColor = .gray100
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
        }

        productImageView.do {
            $0.backgroundColor = .gray100
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        artistNameLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }

        productNameLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.lineBreakMode = .byTruncatingTail
        }
    }

    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(productImageView, popularTagView, artistNameLabel, productNameLabel, potCountTagView)
    }

    private func setLayout() {
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(1)
            $0.height.equalTo(128)
        }
        popularTagView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.height.equalTo(26)
        }
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(artistNameLabel)
            $0.trailing.lessThanOrEqualTo(potCountTagView.snp.leading).offset(-8)
        }
        potCountTagView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(50)
        }
    }

    // MARK: - Public Method

    func configure(with model: GoodsListItemModel) {
        productImageView.kf.setImage(with: model.postImage.flatMap { URL(string: $0) })
        artistNameLabel.text = model.artist
        productNameLabel.text = model.title
        potCountTagView.setTagText(model.postCountText)
        popularTagView.isHidden = !model.hasPopularTag

        if let tag = model.tag, model.hasPopularTag {
            popularTagView.setTagText(tag)
        }
    }
}
