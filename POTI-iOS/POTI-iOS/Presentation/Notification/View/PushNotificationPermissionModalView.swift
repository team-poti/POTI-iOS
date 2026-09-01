//
//  PushNotificationPermissionModalView.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class PushNotificationPermissionModalView: BaseView {

    // MARK: - Properties

    var onTapAllow: (() -> Void)?
    var onTapLater: (() -> Void)?

    // MARK: - UI Components

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let alarmImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let allowButton = UIButton()
    private let laterButton = UIButton()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.6)

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        alarmImageView.do {
            $0.image = .icnAlarmModal.withRenderingMode(.alwaysOriginal)
        }

        titleLabel.do {
            $0.setLabel("푸시 알림을 허용해주세요", font: .title18sb, alignment: .center, color: .potiBlack)
        }

        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.setLabel("분철 진행 상황을 실시간으로 확인할 수 있도록\n알림을 보내드려요.", font: .body14m, alignment: .center, color: .gray800)
        }

        allowButton.do {
            $0.backgroundColor = .poti600
            $0.layer.cornerRadius = 24
            $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.setTitle("푸시 알림 허용", for: .normal)
            $0.setTitleColor(.potiWhite, for: .normal)
        }

        laterButton.do {
            $0.titleLabel?.font = PotiFontManager.button14sb.font
            $0.setTitle("나중에", for: .normal)
            $0.setTitleColor(.poti600, for: .normal)
        }
    }

    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(alarmImageView, titleLabel, descriptionLabel, allowButton, laterButton)
    }

    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(42)
        }

        alarmImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alarmImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        allowButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        laterButton.snp.makeConstraints {
            $0.top.equalTo(allowButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(48)
        }
    }

    override func addTarget() {
        allowButton.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        laterButton.addTarget(self, action: #selector(laterButtonTapped), for: .touchUpInside)
    }

    // MARK: - Private Methods

    private func dismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }

    // MARK: - Public Methods

    func show(in view: UIView) {
        view.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        containerView.alpha = 0
        backgroundView.alpha = 0
        layoutIfNeeded()

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
            self.backgroundView.alpha = 1
        }
    }

    // MARK: - Actions

    @objc private func allowButtonTapped() {
        dismiss(completion: onTapAllow)
    }

    @objc private func laterButtonTapped() {
        dismiss(completion: onTapLater)
    }
}
