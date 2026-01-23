//
//  DetailParticipantsCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
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
    private let memberTagView = TagView(type: .primaryGrayLarge, tagText: "원영")
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
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
            let starImage = UIImage(named: "icn-star")?.withRenderingMode(.alwaysTemplate)
            $0.image = starImage
            $0.tintColor = .gray800
        }
        
        starRatingLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
    }
    
    private func setUI() {
        addSubviews(nickNameLabel, profileImageView, starImageView, starRatingLabel, memberTagView)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
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
            $0.leading.greaterThanOrEqualTo(starRatingLabel.snp.trailing).offset(8)
        }
    }
    
    func configure(_ model: ParticipantDisplayModel) {
        let user = model.userInfo
        
        nickNameLabel.text = user.nickname
        starRatingLabel.text = "\(user.rating)"
        
        if let url = URL(string: user.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
        memberTagView.setTagText(model.selectedMember)
    }
}
