//
//  MyPageView.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let emailLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let ratingView = RatingView(rating: 1.2)
    private let idolButton = ChooseFavoriteIdolButton()
    private let userInformationView = UserInformationView(recentActivity: "최근 3일 이내 활동", signUpDate: "2024-12-28".toDate())
    private let participationLabel = UILabel()
    let participationView = MyPageNavigationView()
    private let recruitmentLabel = UILabel()
    let recruitmentView = MyPageNavigationView()
    
    override func setStyle() {
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        profileImage.do {
            $0.image = .imgDone
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 49
            $0.clipsToBounds = true
        }
        
        nickNameLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
            $0.text = "앙티티"
        }
        
        emailLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.text = "ang@naver.com"
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        participationLabel.do {
            $0.text = "참여 내역"
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
        
        participationView.do {
            $0.configure(counts: (all: 3, ongoing: 2, completed: 1))
        }
        
        recruitmentLabel.do {
            $0.text = "모집 내역"
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
        
        recruitmentView.do {
            $0.configure(counts: (all: 7, ongoing: 2, completed: 5))
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        buttonStackView.addArrangedSubviews(ratingView, idolButton)

        contentView.addSubviews(profileImage, nickNameLabel, emailLabel, buttonStackView, userInformationView, participationLabel, participationView, recruitmentLabel, recruitmentView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
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

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        userInformationView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        participationLabel.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }

        participationView.snp.makeConstraints {
            $0.top.equalTo(participationLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        recruitmentLabel.snp.makeConstraints {
            $0.top.equalTo(participationView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }

        recruitmentView.snp.makeConstraints {
            $0.top.equalTo(recruitmentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(60)
        }
    }
}
