//
//  YourProfileInformationView.swift
//  POTI-iOS
//
//  Created by Neon on 7/8/26.
//


import UIKit

import Kingfisher
import SnapKit
import Then

final class YourProfileInformationView: BaseView {
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let ratingView = RatingView(rating: 0)
    
    private let nickname: String
    private let profileImageURL: String?
    private let ratingAverage: Double
    
    init(nickname: String, profileImageURL: String?, ratingAverage: Double) {
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.ratingAverage = ratingAverage
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .potiWhite
        layer.cornerRadius = 12
        
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    override func setUI() {
        addSubviews(profileImage, nickNameLabel, ratingView)
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(67)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(98)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(47)
        }
    }
}

extension YourProfileInformationView {
    func configure(nickname: String, profileImageURL: String?, ratingAverage: Double) {
        nickNameLabel.text = nickname
        if let imageURL = profileImageURL,
           let url = URL(string: imageURL) {
            
            profileImage.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .profilepic),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            profileImage.kf.cancelDownloadTask()
            profileImage.image = UIImage(resource: .profilepic)
        }
        
        ratingView.update(rating: ratingAverage)
    }
}
