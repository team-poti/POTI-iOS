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

    private let titleLabel = UILabel()
    private let countLabel = UILabel()

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

    // MARK: - Custom Methods

    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.text = "참여자"
        }

        countLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .poti600
        }

        nickNameLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
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
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
    }

    private func setUI() {
        contentView.addSubviews(
            titleLabel, countLabel,
            nickNameLabel, profileImageView, starImageView, starRatingLabel, memberTagView
        )
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

        profileImageView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.size.equalTo(52)
        }

        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImageView)
        }

        starImageView.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(nickNameLabel)
            $0.size.equalTo(21)
        }

        starRatingLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing)
        }

        memberTagView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo(29)
            $0.centerY.equalTo(nickNameLabel)
        }
    }

    // MARK: - Public Method

    func configure(model: ParticipantModel, index: Int, currentCount: Int, totalCount: Int) {
        if index == 0 {
            titleLabel.isHidden = false
            countLabel.isHidden = false
            countLabel.text = "\(currentCount)/\(totalCount)"

            profileImageView.snp.remakeConstraints {
                $0.leading.bottom.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                $0.size.equalTo(52)
            }
        } else {
            titleLabel.isHidden = true
            countLabel.isHidden = true

            profileImageView.snp.remakeConstraints {
                $0.leading.bottom.equalToSuperview()
                $0.top.equalToSuperview()
                $0.size.equalTo(52)
            }
        }

        let user = model.userInfo
        nickNameLabel.text = user.nickname
        starRatingLabel.text = "\(user.rating)"
        profileImageView.kf.setImage(with: URL(string: user.profileImage))

        memberTagView.setTagText(model.selectedMember)
    }
}
