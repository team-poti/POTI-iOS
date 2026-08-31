//
//  GuestMyPageView.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

import UIKit

import SnapKit
import Then

final class GuestMyPageView: BaseView {
    private let cardView = UIView()
    private let contentStackView = UIStackView()
    private let profileStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let messageLabel = UILabel()
    let loginButton = UIButton()

    override func setStyle() {
        backgroundColor = .gray100

        cardView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 24
        }

        profileStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 12
        }

        profileImageView.do {
            $0.image = UIImage(resource: .profilepic)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        messageLabel.do {
            $0.text = "로그인하고 원하는 분철에\n참여해보세요!"
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }

        var configuration = UIButton.Configuration.plain()
        configuration.title = "로그인"
        configuration.image = .icnArrowRightSm
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 0
        configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 8)
        configuration.baseForegroundColor = .potiBlack
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = PotiFontManager.body14m.font
            return attributes
        }
        loginButton.configuration = configuration
        loginButton.backgroundColor = .poti400
        loginButton.layer.cornerRadius = 20
    }

    override func setUI() {
        addSubview(cardView)
        cardView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(profileStackView, loginButton)
        profileStackView.addArrangedSubviews(profileImageView, messageLabel)
    }

    override func setLayout() {
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(.dynamicH(114) + 16)
        }

        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(98)
        }

        loginButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
}
