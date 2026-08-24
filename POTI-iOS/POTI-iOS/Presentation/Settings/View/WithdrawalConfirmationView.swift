//
//  WithdrawalConfirmationView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class WithdrawalConfirmationView: BaseView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let cancelButton = UIButton()
    private let confirmButton = UIButton()
    private let onConfirm: () -> Void

    init(onConfirm: @escaping () -> Void) {
        self.onConfirm = onConfirm
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
        }
        titleLabel.do {
            $0.text = "정말 탈퇴하시겠어요?"
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }
        messageLabel.do {
            $0.text = "회원탈퇴 후에는 계정 정보가 모두 삭제되며,\n복구할 수 없어요."
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        cancelButton.do {
            $0.setTitle("취소", for: .normal); $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.setTitleColor(.gray900, for: .normal); $0.backgroundColor = .gray100; $0.layer.cornerRadius = 24
        }
        confirmButton.do {
            $0.setTitle("탈퇴", for: .normal); $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.setTitleColor(.potiWhite, for: .normal); $0.backgroundColor = .gray900; $0.layer.cornerRadius = 24
        }
    }

    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(cancelButton, confirmButton)
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.equalTo(176)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }

    func show(on view: UIView) {
        view.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    @objc private func dismiss() { removeFromSuperview() }
    @objc private func confirmTapped() { dismiss(); onConfirm() }
}
