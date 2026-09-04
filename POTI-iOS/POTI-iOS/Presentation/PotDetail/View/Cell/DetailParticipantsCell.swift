//
//  DetailParticipantsCell.swift
//  POTI-iOS
//
//  Created by soomin on 1/18/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DetailParticipantsCell: UICollectionViewCell {

    // MARK: - UI Components

    private let profileImageView = UIImageView()
    private let nickNameLabel = UILabel()
    private let starImageView = UIImageView()
    private let starRatingLabel = UILabel()
    private let memberTagView = TagView(type: .primaryGrayLarge)

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
    }

    // MARK: - Custom Methods

    private func setStyle() {
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
    }

    private func setUI() {
        contentView.addSubviews(
            nickNameLabel, profileImageView, starImageView, starRatingLabel, memberTagView
        )
    }

    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.size.equalTo(52)
        }

        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImageView)
        }

        starImageView.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(4)
            $0.top.equalTo(nickNameLabel).offset(2)
            $0.size.equalTo(21)
        }

        starRatingLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel)
            $0.leading.equalTo(starImageView.snp.trailing)
        }

        memberTagView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo(29)
            $0.centerY.equalTo(nickNameLabel)
        }
    }

    // MARK: - Public Method

    func configure(model: ParticipantModel) {
        let user = model.userInfo
        nickNameLabel.setLabel(user.nickname, font: .body14sb, color: .potiBlack)
        starRatingLabel.setLabel("\(user.rating)", font: .body14m, color: .gray800)
        profileImageView.kf.setImage(with: URL(string: user.profileImage))

        memberTagView.setTagText(model.selectedMember)
    }
}

final class DetailParticipantsHeaderView: UICollectionReusableView {

    private let titleLabel = UILabel()
    private let countLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        titleLabel.do {
            $0.setLabel("참여자", font: .body16sb, color: .potiBlack)
        }

        countLabel.do {
            $0.setLabel("", font: .body16sb, color: .poti600)
        }
    }

    private func setUI() {
        addSubviews(titleLabel, countLabel)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        countLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
    }

    func configure(currentCount: Int, totalCount: Int) {
        countLabel.setLabel("\(currentCount)/\(totalCount)", font: .body16sb, color: .poti600)
    }
}
