//
//  DetailUploaderCell.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class DetailUploaderCell: UICollectionViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nickNameLabel = UILabel()
    private let starImageView = UIImageView()
    private let starRatingLabel = UILabel()
    private let reviewLabel = UILabel()
    let profileDetailButton = UIButton()
    private let dividerView = UIView()

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
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = nil
        profileDetailButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    // MARK: - Custom Methods

    private func setStyle() {
        titleLabel.do {
            $0.setLabel("모집자", font: .body16sb, color: .potiBlack)
        }

        nickNameLabel.do {
            $0.setLabel("", font: .body14sb, color: .potiBlack)
        }

        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 26
            $0.clipsToBounds = true
        }

        starImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: "icn-star")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray800
        }

        starRatingLabel.do {
            $0.setLabel("", font: .body14m, color: .gray800)
        }

        reviewLabel.do {
            $0.setLabel("", font: .body14m, color: .gray800)
        }

        profileDetailButton.do {
            $0.contentMode = .scaleAspectFill
            $0.setImage(UIImage(named: "icn-arrow-right-lg")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray700
        }

        dividerView.do {
            $0.backgroundColor = .gray300
        }
    }

    private func setUI() {
        contentView.addSubviews(titleLabel, nickNameLabel, profileImageView, starImageView,
            starRatingLabel, reviewLabel, profileDetailButton, dividerView
        )
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.size.equalTo(52)
        }

        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.top.equalTo(profileImageView.snp.top).offset(3)
        }

        starImageView.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(4)
            $0.top.equalTo(nickNameLabel).offset(2)
            $0.size.equalTo(21)
        }

        starRatingLabel.snp.makeConstraints {
            $0.leading.equalTo(starImageView.snp.trailing)
            $0.top.equalTo(nickNameLabel.snp.top)
        }

        reviewLabel.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-3)
        }

        profileDetailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(profileImageView)
            $0.size.equalTo(24)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Method

    func configure(with model: UploaderModel, target: Any?, action: Selector) {
        nickNameLabel.setLabel(model.nickname, font: .body14sb, color: .potiBlack)
        starRatingLabel.setLabel("\(model.rating)", font: .body14m, color: .gray800)
        reviewLabel.setLabel("\(model.reviewCount)개의 평가", font: .body14m, color: .gray800)
        profileImageView.kf.setImage(with: URL(string: model.profileImage))

        profileDetailButton.removeTarget(nil, action: nil, for: .allEvents)
        profileDetailButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
