//
//  WithdrawalUnavailableView.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

import UIKit

import SnapKit
import Then

final class WithdrawalUnavailableView: BaseView {
    private let containerView = UIView()
    private let noticeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let confirmButton = UIButton()

    override func setStyle() {
        backgroundColor = .black.withAlphaComponent(0.6)

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        noticeImageView.do {
            $0.image = UIImage(resource: .icnNoticeLg)
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.text = "회원탈퇴를 할 수 없어요"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }

        messageLabel.do {
            $0.text = "진행 중인 모집이나 참여 내역이 있어 지금은\n탈퇴할 수 없어요. 진행 중인 거래가 모두 종료된\n후 다시 시도해 주세요."
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }

        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.backgroundColor = .potiBlack
            $0.layer.cornerRadius = 24
        }
    }

    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(noticeImageView, titleLabel, messageLabel, confirmButton)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(291)
            $0.height.equalTo(280)
        }

        noticeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(48)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(96)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }

    override func addTarget() {
        confirmButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }

    func show(on view: UIView) {
        guard !view.subviews.contains(where: { $0 is WithdrawalUnavailableView }) else {
            return
        }

        view.addSubview(self)
        snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    @objc private func dismiss() {
        removeFromSuperview()
    }
}
