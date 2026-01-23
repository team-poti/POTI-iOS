//
//  YourPageView.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class YourPageView: BaseView {
    
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ratingView = RatingView(rating: 0)
    private let userInformationView = UserInformationView(recentActivity: "", signUpDate: "")
    private let recruitmentLabel = UILabel()
    let recruitmentView = MyPageNavigationView()
    
    override func setStyle() {
        profileImage.do {
            $0.image = .imgDone
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        nickNameLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }
        
        emailLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        recruitmentLabel.do {
            $0.text = "모집 내역"
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    override func setUI() {
        addSubviews(profileImage, nickNameLabel, emailLabel, ratingView, userInformationView, recruitmentLabel, recruitmentView)
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(98)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        userInformationView.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        recruitmentLabel.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        recruitmentView.snp.makeConstraints {
            $0.top.equalTo(recruitmentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension YourPageView {
    func configure(with model: YourPageModel) {
        nickNameLabel.text = model.nickname
        emailLabel.text = model.email
        if let imageURL = model.profileImage,
           let url = URL(string: imageURL) {
            
            profileImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_profile_placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
        }

        ratingView.update(rating: model.ratingAverage)

        userInformationView.configure(
            recentActivity: model.activityMessage,
            signUpDate: model.joinedDate
        )

        recruitmentView.configure(
            counts: (
                all: model.recruitSummary.totalCount,
                ongoing: model.recruitSummary.inProgressCount,
                completed: model.recruitSummary.completedCount
            )
        )
    }
}
