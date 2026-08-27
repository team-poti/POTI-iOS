//
//  NotificationSettingView.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class NotificationSettingView: BaseView {

    // MARK: - UI Components

    let tradeToggle = PotiToggle()
    let eventToggle = PotiToggle()

    private let tradeTitleLabel = UILabel()
    private let tradeDescriptionLabel = UILabel()
    private let eventTitleLabel = UILabel()
    private let eventDescriptionLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .potiWhite

        tradeTitleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.text = "거래 알림"
        }

        tradeDescriptionLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.text = "분철 모집/참여 거래 알림"
        }

        eventTitleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.text = "이벤트 및 혜택 알림"
        }

        eventDescriptionLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.text = "광고성 정보 수신 및 마케팅 알림"
        }
    }

    override func setUI() {
        addSubviews(tradeTitleLabel, tradeDescriptionLabel, tradeToggle, eventTitleLabel, eventDescriptionLabel, eventToggle)
    }

    override func setLayout() {
        tradeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(16)
        }

        tradeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tradeTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(tradeTitleLabel)
        }

        tradeToggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(tradeTitleLabel.snp.bottom).offset(11.5)
        }

        eventTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tradeDescriptionLabel.snp.bottom).offset(31)
            $0.leading.equalTo(tradeTitleLabel)
        }

        eventDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(eventTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(eventTitleLabel)
        }

        eventToggle.snp.makeConstraints {
            $0.trailing.equalTo(tradeToggle)
            $0.centerY.equalTo(eventTitleLabel.snp.bottom).offset(11.5)
        }
    }

    // MARK: - Public Methods

    func configure(isTradeNotificationOn: Bool, isEventNotificationOn: Bool) {
        tradeToggle.setOn(isTradeNotificationOn, animated: false)
        eventToggle.setOn(isEventNotificationOn, animated: false)
    }
}
