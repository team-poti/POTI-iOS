//
//  MyPageView.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView, NavigationConfigurable {
    func navigationStyle() -> PotiNavigationStyle {
        .mypage
    }
    
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ratingView = RatingView(rating: 1.2)
    private let idolButton = ChooseFavoriteIdolButton()
    private let userInformationView = UserInformationView(recentActivity: "최근 3일 이내 활동", signUpDate: "2024-12-28".toDate())
    
    
}
