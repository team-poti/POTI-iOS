//
//  UserInformationView.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class UserInformationView: BaseView {
    
    private let firstBulletImage = UIImageView()
    private let recentActivityLabel = UILabel()
    private let secondBulletImage = UIImageView()
    private let signUpDateLabel = UILabel()
    
    private let recentActivity: String
    private let signUpDate: Date
    
    init(recentActivity: String, signUpDate: Date) {
        self.recentActivity = recentActivity
        self.signUpDate = signUpDate
        super.init(frame: .zero)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .gray100
        layer.cornerRadius = 12
        
        firstBulletImage.do {
            $0.image = .icnBullet
            $0.tintColor = .gray800
            $0.contentMode = .scaleAspectFit
        }
        
        recentActivityLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.caption12m.font
            $0.text = recentActivity
        }
        
        secondBulletImage.do {
            $0.image = .icnBullet
            $0.tintColor = .gray800
            $0.contentMode = .scaleAspectFit
        }
        
        signUpDateLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.caption12m.font
            $0.text = "\(signUpDate.toKoreanYMD()) 가입"
        }
    }
    
    override func setUI() {
        addSubviews(firstBulletImage, recentActivityLabel, secondBulletImage, signUpDateLabel)
    }
    
    override func setLayout() {
        firstBulletImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.leading.equalToSuperview().inset(12)
        }
        
        recentActivityLabel.snp.makeConstraints {
            $0.leading.equalTo(firstBulletImage.snp.trailing)
            $0.centerY.equalTo(firstBulletImage)
        }
        
        secondBulletImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(firstBulletImage.snp.bottom)
            $0.leading.bottom.equalToSuperview().inset(12)
        }
        
        signUpDateLabel.snp.makeConstraints {
            $0.leading.equalTo(secondBulletImage.snp.trailing)
            $0.centerY.equalTo(firstBulletImage)
        }
    }
}
