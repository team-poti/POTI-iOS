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
    
    private let profileInformationView = ProfileInformationView(nickname: "", email: "", profileImageURL: "", ratingAverage: 0, hasFavoriteArtist: false, favoriteArtistName: "")
    
    private let userInformationView = UserInformationView(recentActivity: "", signUpDate: "")
    
    let participationView = MyPageNavigationView()
    let recruitmentView = MyPageNavigationView()
    
    private let inquiryInfoView = InquiryInformationView()
    
    override func setStyle() {
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(profileInformationView, userInformationView, participationView, recruitmentView, inquiryInfoView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        profileInformationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        userInformationView.snp.makeConstraints {
            $0.top.equalTo(profileInformationView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        participationView.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(recruitmentView.snp.leading).offset(-12)
            $0.width.equalTo(recruitmentView)
        }
        
        recruitmentView.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(participationView.snp.trailing).offset(12)
        }
        
        inquiryInfoView.snp.makeConstraints {
            $0.top.equalTo(recruitmentView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(37)
        }
    }
}

extension MyPageView {
    func configure(with model: MyPageModel) {
    
        profileInformationView.configure(nickname: model.nickname, email: model.email, profileImageURL: model.profileImage, ratingAverage: model.ratingAverage, hasFavoriteArtist: model.hasFavoriteArtist, favoriteArtistName: model.favoriteArtistName)

        userInformationView.configure(
            recentActivity: model.activityMessage,
            signUpDate: model.joinedDate
        )

        participationView.configure(
            title: "참여 내역",
            counts: (
                ongoing: model.participationSummary.inProgressCount,
                completed: model.participationSummary.completedCount
            )
        )

        recruitmentView.configure(
            title: "모집 내역",
            counts: (
                ongoing: model.recruitSummary.inProgressCount,
                completed: model.recruitSummary.completedCount
            )
        )
    }
}
