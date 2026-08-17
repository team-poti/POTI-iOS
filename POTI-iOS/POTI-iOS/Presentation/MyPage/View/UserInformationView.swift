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
    
    private let recentActivityLabel = UILabel()
    private let bulletImage = UIImageView()
    private let signUpDateLabel = UILabel()
    private let userInformationStackView = UIStackView()
    
    private let recentActivity: String
    private let signUpDate: String
    
    init(recentActivity: String, signUpDate: String) {
        self.recentActivity = recentActivity
        self.signUpDate = signUpDate
        super.init(frame: .zero)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .potiWhite
        layer.cornerRadius = 12
        
        recentActivityLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
            $0.text = recentActivity
        }
        
        bulletImage.do {
            $0.image = .icnBullet
            $0.tintColor = .gray800
            $0.contentMode = .scaleAspectFit
        }
        
        signUpDateLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
        }
        
        userInformationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
    }
    
    override func setUI() {
        addSubviews(userInformationStackView)
        userInformationStackView.addArrangedSubviews(recentActivityLabel, bulletImage, signUpDateLabel)
    }
    
    override func setLayout() {
        userInformationStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(17.5)
        }
    }
}

extension UserInformationView {
    func configure(recentActivity: String, signUpDate: String) {
        recentActivityLabel.text = recentActivity
        signUpDateLabel.text = "\(signUpDate.toKoreanYMD() ?? "") 가입"
    }
}
