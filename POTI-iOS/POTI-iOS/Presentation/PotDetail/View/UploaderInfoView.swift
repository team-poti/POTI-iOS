//
//  UploaderInfoView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class UploaderInfoView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nickNameLabel = UILabel()
    private let starImageView = UIImageView()
    private let starRatingLabel = UILabel()
    private let reviewLabel = UILabel()
    let profileDetailButton = UIButton()
    private let dividerView = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }
        
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
        
        reviewLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        profileDetailButton.do {
            $0.contentMode = .scaleAspectFill
            let arrowImage = UIImage(named: "icn-arrow-right-lg")?.withRenderingMode(.alwaysTemplate)
            $0.setImage(arrowImage, for: .normal)
            $0.tintColor = .gray700
        }
        
        dividerView.do {
            $0.backgroundColor = .gray300
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            nickNameLabel,
            profileImageView,
            starImageView,
            starRatingLabel,
            reviewLabel,
            profileDetailButton,
            dividerView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.size.equalTo(52)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.top.equalTo(profileImageView.snp.top).offset(6)
        }
        
        starImageView.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(4)
            $0.top.equalTo(nickNameLabel.snp.top).offset(-2)
            $0.size.equalTo(21)
        }
        
        starRatingLabel.snp.makeConstraints {
            $0.leading.equalTo(starImageView.snp.trailing)
            $0.top.equalTo(nickNameLabel.snp.top)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-6)
        }
        
        profileDetailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(profileImageView)
            $0.size.equalTo(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    func configure(with model: UploaderModel) {
        nickNameLabel.text = model.nickname
        starRatingLabel.text = "\(model.rating)"
        reviewLabel.text = "\(model.reviewCount)개의 평가"
        profileImageView.kf.setImage(with: URL(string: model.profileImage ?? ""))
        titleLabel.text = "모집자"
    }
}

