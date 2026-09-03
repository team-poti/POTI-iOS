//
//  PotListCell.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

enum PotListStatus: String {
    case recruiting = "RECRUITING"
    case closed = "CLOSED"
}

final class PotListCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let userProfileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let starRatingStackView = UIStackView()
    private let starIcon = UIImageView()
    private let starScoreLabel = UILabel()
    private let countLabel = UILabel()
    
    private let separator = UIView()
    
    private let memberContainerView = UIView()
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
    
    override func prepareForReuse() {
        self.containerView.alpha = 1.0
        self.countLabel.alpha = 1.0
        self.countLabel.attributedText = nil
        self.countLabel.text = nil
        self.priceLabel.alpha = 1.0
        self.productImageView.alpha = 1.0
        self.containerView.layer.borderColor = UIColor.gray300.cgColor
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
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 17.5
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.setLabel("", font: .body14m, color: .potiBlack)
        }
        
        starIcon.do {
            $0.contentMode = .scaleAspectFill
            let starImage = UIImage(named: "icn-star")?.withRenderingMode(.alwaysTemplate)
            $0.image = starImage
            $0.tintColor = .gray800
            $0.transform = CGAffineTransform(translationX: 0, y: 2)
        }
        
        starScoreLabel.do {
            $0.setLabel("", font: .body14m, color: .gray800)
        }

        starRatingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .top
        }
        
        countLabel.do {
            $0.setLabel("", font: .display18b, color: .sementicRed)
        }
        
        separator.do {
            $0.backgroundColor = .gray300
        }
        
        productImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        priceLabel.do {
            $0.setLabel("", font: .display18b, color: .potiBlack)
        }
    }
    
    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            userProfileImageView, userNicknameLabel, starRatingStackView, countLabel,
            separator,
            memberContainerView, priceLabel, productImageView
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
        
        memberContainerView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(16)
            $0.leading.equalTo(separator)
            $0.trailing.equalTo(productImageView.snp.leading).offset(-30)
            $0.height.equalTo(46)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(memberContainerView)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        productImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(separator.snp.bottom).offset(16)
            $0.size.equalTo(75)
        }
    }
}

// MARK: - Extension

extension PotListCell {
    func configure(model: PotModel) {
        userProfileImageView.kf.setImage(with: URL(string: model.recruiter.profileImage))
        userNicknameLabel.setLabel(model.recruiter.nickname, font: .body14m, color: .potiBlack)
        starScoreLabel.setLabel("\(model.recruiter.rating)", font: .body14m, color: .gray800)
        
        productImageView.kf.setImage(with: URL(string: model.thumbnailUrl))
        setPriceLabel(price: model.price)
        
        let status = PotListStatus(rawValue: model.status) ?? .recruiting
        updateUI(status: status, model: model)
    }
    
    private func updateUI(status: PotListStatus, model: PotModel) {
        let isClosed = (status == .closed)
        let alpha: CGFloat = isClosed ? 0.5 : 1.0
        
        [userProfileImageView, userNicknameLabel, starScoreLabel, starIcon, priceLabel, productImageView].forEach {
            $0.alpha = alpha
        }
        memberContainerView.isHidden = isClosed
        
        if isClosed {
            setClosedStyle()
        } else {
            setRecruitingStyle(
                current: model.currentCount,
                total: model.totalCount,
                members: model.availableMembers
            )
        }
    }
    
    private func setClosedStyle() {
        countLabel.setLabel("마감", font: .body16sb, color: .gray800.withAlphaComponent(0.5))
    }
    
    private func setRecruitingStyle(current: Int, total: Int, members: [String]) {
        countLabel.alpha = 1.0
        let currentString = "\(current.formattedWithComma)"
        let totalString = "/\(total.formattedWithComma)"
        let fullCountText = NSMutableAttributedString(string: currentString + totalString)
        
        let currentRange = NSRange(location: 0, length: currentString.count)
        fullCountText.addAttributes([
            .foregroundColor: UIColor.sementicRed,
            .font: PotiFontManager.display18b.font
        ], range: currentRange)
        
        let totalRange = NSRange(location: currentString.count, length: totalString.count)
        fullCountText.addAttributes([
            .foregroundColor: UIColor.sementicRed,
            .font: PotiFontManager.body16sb.font
        ], range: totalRange)
        
        countLabel.setLabel(fullCountText, lineHeight: .display18b)
        
        configureMemberTags(members)
    }
    
    private func setPriceLabel(price: Int) {
        let priceString = "\(price.formattedWithComma)원~"
        let perPersonString = " / 인"
        let fullPriceText = NSMutableAttributedString(string: priceString + perPersonString)
        
        fullPriceText.addAttributes([
            .foregroundColor: UIColor.potiBlack,
            .font: PotiFontManager.display18b.font
        ], range: NSRange(location: 0, length: fullPriceText.length))
        fullPriceText.addAttributes([
            .foregroundColor: UIColor.gray800,
            .font: PotiFontManager.body14m.font
        ], range: (fullPriceText.string as NSString).range(of: perPersonString))
        priceLabel.setLabel(fullPriceText, lineHeight: .display18b)
    }
    
    private func configureMemberTags(_ members: [String]) {
        memberContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let maxWidth: CGFloat = 200
        let maxLines = 2
        let lineHeight = PotiFontManager.body14m.fontProperty.lineHeight
        let itemSpacing: CGFloat = 4
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentLine = 1
        
        for member in members {
            let text = "\(member) |"
            
            let label = UILabel()
            label.setLabel(text, font: .body14m, color: .gray800)
            
            let size = label.intrinsicContentSize
            
            if currentX + size.width > maxWidth {
                
                currentLine += 1
                
                if currentLine > maxLines {
                    addEllipsis(x: currentX, y: currentY)
                    return
                }
                
                currentX = 0
                currentY += lineHeight + itemSpacing
            }
            
            if currentLine == maxLines {
                let ellipsisWidth = ("..." as NSString).size(
                    withAttributes: [.font: PotiFontManager.body14m.font]
                ).width
                
                if currentX + size.width + ellipsisWidth > maxWidth {
                    addEllipsis(x: currentX, y: currentY)
                    return
                }
            }
            
            memberContainerView.addSubview(label)
            
            label.frame = CGRect(
                x: currentX,
                y: currentY,
                width: size.width,
                height: lineHeight
            )
            
            currentX += size.width + itemSpacing
        }
    }
    
    private func addEllipsis(x: CGFloat, y: CGFloat) {
        let label = UILabel()
        label.setLabel("...", font: .body14m, color: .gray800)
        
        memberContainerView.addSubview(label)
        
        label.frame = CGRect(
            x: x,
            y: y,
            width: label.intrinsicContentSize.width,
            height: PotiFontManager.body14m.fontProperty.lineHeight
        )
    }
}
