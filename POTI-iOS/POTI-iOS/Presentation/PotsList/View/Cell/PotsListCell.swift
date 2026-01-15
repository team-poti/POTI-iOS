//
//  PotsListCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PotsListCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let userProfileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let starRatingStackView = UIStackView()
    private let starIcon = UIImageView()
    private let starScoreLabel = UILabel()
    private let countLabel = UILabel()
    
    private let separator = UIView()
    
    private let memberListLabel = UILabel()
    private let priceLabel = UILabel()
    private let productImageView = UIImageView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        containerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
        }
        
        userProfileImageView.do {
            $0.layer.cornerRadius = 17.5
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14m.font
        }
        
        starIcon.do {
            $0.contentMode = .scaleAspectFill
            let starImage = UIImage(named: "icn-star")?.withRenderingMode(.alwaysTemplate)
            $0.image = starImage
            $0.tintColor = .gray800
        }
        
        starScoreLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
        }
        
        countLabel.do {
            $0.textColor = .sementicRed
            $0.font = PotiFontManager.display18b.font
        }
        
        separator.do {
            $0.backgroundColor = .gray300
        }
        
        memberListLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.caption12m.font
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        productImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        priceLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.display18b.font
        }
    }
    
    private func setUI() {
        addSubview(containerView)
        containerView.addSubviews(
            userProfileImageView, userNicknameLabel, starRatingStackView, countLabel,
            separator,
            memberListLabel, priceLabel, productImageView
        )
        starRatingStackView.addArrangedSubviews(starIcon, starScoreLabel)
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(35)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
        }
        
        starRatingStackView.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom)
            $0.leading.equalTo(userNicknameLabel.snp.leading).offset(-5)
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(21)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        memberListLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(16)
            $0.leading.equalTo(separator)
            $0.trailing.equalTo(productImageView.snp.leading).offset(-12)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(memberListLabel)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        productImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(separator.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(15)
            $0.size.equalTo(75)
        }
    }
}

// MARK: - Extension

extension PotsListCell {
    func configure(pot: Pot) {
        userProfileImageView.kf.setImage(with: URL(string: pot.profileImage))
        userNicknameLabel.text = pot.user.nickname
        starScoreLabel.text = "\(pot.rating)"
        productImageView.kf.setImage(with: URL(string: pot.thumbnailUrl))
        
        // TODO: - 서현이 formatter extension 연결하기
        
        let priceString = "\(pot.price)원~"
        let perPersonString = " / 인"
        let fullPriceText = NSMutableAttributedString(string: priceString + perPersonString)
        
        fullPriceText.addAttribute(.foregroundColor, value: UIColor.gray800, range: (fullPriceText.string as NSString).range(of: perPersonString))
        fullPriceText.addAttribute(.font, value: PotiFontManager.body14m.font, range: (fullPriceText.string as NSString).range(of: perPersonString))
        priceLabel.attributedText = fullPriceText
        
        let currentString = "\(pot.currentCount)"
        let totalString = "/\(pot.totalCount)"
        let fullCountText = NSMutableAttributedString(string: currentString + totalString)
        
        fullCountText.addAttribute(.foregroundColor, value: UIColor.sementicRed, range: (fullCountText.string as NSString).range(of: totalString))
        fullCountText.addAttribute(.font, value: PotiFontManager.body16sb.font, range: (fullCountText.string as NSString).range(of: totalString))
        countLabel.attributedText = fullCountText
        
        // TODO: - (멤버이름 |) 을 한 세트로 움직이게 하기
        
        let joinedMembers = pot.availableMembers.joined(separator: " | ")

        memberListLabel.text = joinedMembers
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4

        let attributedString = NSMutableAttributedString(string: memberListLabel.text ?? "")
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        memberListLabel.attributedText = attributedString
    }
}
