//
//  YourPageView.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import UIKit

import SnapKit
import Then

final class YourPageView: BaseView {
    
    private let yourProfileInfoView = YourProfileInformationView(nickname: "", profileImageURL: "", ratingAverage: 0)
    
    private let userInformationView = UserInformationView(recentActivity: "", signUpDate: "")
    
    let participationView = MyPageNavigationView()
    let recruitmentView = MyPageNavigationView()
    
    override func setUI() {
        addSubviews(yourProfileInfoView, userInformationView, participationView, recruitmentView)
    }
    
    override func setLayout() {
        yourProfileInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        userInformationView.snp.makeConstraints {
            $0.top.equalTo(yourProfileInfoView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        participationView.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        recruitmentView.snp.makeConstraints {
            $0.top.equalTo(userInformationView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension YourPageView {
    func configure(with model: YourPageModel) {
        
        yourProfileInfoView.configure(nickname: model.nickname, profileImageURL: model.profileImage, ratingAverage: model.ratingAverage)

        userInformationView.configure(
            recentActivity: model.activityMessage,
            signUpDate: model.joinedDate
        )
        
        // TODO: - 추후 변경
        participationView.configure(
            title: MyPageNavigationTitle.participation,
            counts: (
                ongoing: model.recruitSummary.inProgressCount,
                completed: model.recruitSummary.completedCount
            )
        )

        recruitmentView.configure(
            title: MyPageNavigationTitle.recruitment,
            counts: (
                ongoing: model.recruitSummary.inProgressCount,
                completed: model.recruitSummary.completedCount
            )
        )
    }
}
