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
    private let tradeStackView = UIStackView()
    private let eventTitleLabel = UILabel()
    private let eventDescriptionLabel = UILabel()
    private let eventStackView = UIStackView()

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

        tradeStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
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

        eventStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
    }

    override func setUI() {
        tradeStackView.addArrangedSubviews(tradeTitleLabel, tradeDescriptionLabel)
        eventStackView.addArrangedSubviews(eventTitleLabel, eventDescriptionLabel)
        addSubviews(tradeStackView, tradeToggle, eventStackView, eventToggle)
    }

    override func setLayout() {
        tradeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(tradeToggle.snp.leading).offset(-16)
        }

        tradeToggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(tradeStackView)
        }

        eventStackView.snp.makeConstraints {
            $0.top.equalTo(tradeStackView.snp.bottom).offset(31)
            $0.leading.equalTo(tradeStackView)
            $0.trailing.lessThanOrEqualTo(eventToggle.snp.leading).offset(-16)
        }

        eventToggle.snp.makeConstraints {
            $0.trailing.equalTo(tradeToggle)
            $0.centerY.equalTo(eventStackView)
        }
    }

    // MARK: - Public Method

    func configure(isTradeNotificationOn: Bool, isEventNotificationOn: Bool) {
        tradeToggle.setOn(isTradeNotificationOn, animated: false)
        eventToggle.setOn(isEventNotificationOn, animated: false)
    }
}
