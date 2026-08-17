//
//  ProfileInformationView.swift
//  POTI-iOS
//
//  Created by Neon on 7/6/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class ProfileInformationView: BaseView {
    
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let emailLabel = UILabel()
    private let buttonStackView = UIStackView()
    
    private let ratingView = RatingView(rating: 0)
    let idolButton = ChooseFavoriteIdolButton()
    
    private let nickname: String
    private let email: String
    private let profileImageURL: String?
    
    private let ratingAverage: Double
    
    private let hasFavoriteArtist: Bool
    private let favoriteArtistName: String?
    
    init(nickname: String, email: String, profileImageURL: String?, ratingAverage: Double, hasFavoriteArtist: Bool, favoriteArtistName: String?) {
        self.nickname = nickname
        self.email = email
        self.profileImageURL = profileImageURL
        self.ratingAverage = ratingAverage
        self.hasFavoriteArtist = hasFavoriteArtist
        self.favoriteArtistName = favoriteArtistName
        
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
        
        emailLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    override func setUI() {
        buttonStackView.addArrangedSubviews(ratingView, idolButton)
        
        addSubviews(profileImage, nickNameLabel, emailLabel, buttonStackView)
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
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
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(37)
        }
    }
}

extension ProfileInformationView {
    func configure(nickname: String, email: String, profileImageURL: String?, ratingAverage: Double, hasFavoriteArtist: Bool, favoriteArtistName: String?) {
        nickNameLabel.text = nickname
        emailLabel.text = email
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
        
        idolButton.configure(
            hasFavoriteArtist: hasFavoriteArtist,
            favoriteArtistName: favoriteArtistName
        )
    }
}
