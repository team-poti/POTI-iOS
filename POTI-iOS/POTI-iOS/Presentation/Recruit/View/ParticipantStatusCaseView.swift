//
//  ParticipantStatusCaseView.swift
//  POTI-iOS
//
//  Created by Neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

private protocol ParticipantManagementState {
    var isDetailVisible: Bool { get }
    var actionTitle: String? { get }
    func informationItems(for model: ParticipantManageModel) -> [(title: String, infos: [String])]
}

private struct WaitingParticipantState: ParticipantManagementState {
    let isDetailVisible = false
    let actionTitle: String? = nil

    func informationItems(
        for model: ParticipantManageModel
    ) -> [(title: String, infos: [String])] {
        []
    }
}

private struct DepositCheckingParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let actionTitle: String? = "입금 확인"

    func informationItems(
        for model: ParticipantManageModel
    ) -> [(title: String, infos: [String])] {
        [
            (
                title: "입금 정보",
                infos: [
                    model.waitPayCheckInfo?.depositorName ?? "",
                    model.waitPayCheckInfo?.depositTimeText ?? ""
                ]
            )
        ]
    }
}

private struct PaidParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let actionTitle: String? = "송장 번호 입력"

    func informationItems(
        for model: ParticipantManageModel
    ) -> [(title: String, infos: [String])] {
        [
            (title: "이름", infos: [model.shipInfo?.receiverName ?? ""]),
            (title: "배송 정보", infos: [model.shipInfo?.addressText ?? ""]),
            (title: "연락처", infos: [model.shipInfo?.phoneText ?? ""])
        ]
    }
}

private struct TrackingParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let actionTitle: String? = nil

    func informationItems(
        for model: ParticipantManageModel
    ) -> [(title: String, infos: [String])] {
        [
            (title: "송장 번호", infos: [model.shipInfo?.trackingNumber ?? ""])
        ]
    }
}

private enum ParticipantManagementStateFactory {
    static func make(status: ParticipantStatus) -> any ParticipantManagementState {
        switch status {
        case .recruiting, .waitPay:
            return WaitingParticipantState()
        case .waitPayCheck:
            return DepositCheckingParticipantState()
        case .paid:
            return PaidParticipantState()
        case .shipped, .delivered:
            return TrackingParticipantState()
        }
    }
}

final class ParticipantStatusCaseView: BaseView {

    private let containerStackView = UIStackView()
    private let infoLabelStackView = InfoLabelStackView()
    private let actionButton = UIButton()

    private var onTapAction : (() -> Void)?

    // MARK: - Custom Method

    override func setStyle() {
        clipsToBounds = true
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fill
        }

        actionButton.do {
            $0.setTitleColor(.gray300, for: .normal)
            $0.backgroundColor = .potiBlack
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = PotiFontManager.body14sb.font
            $0.isHidden = true
        }
    }

    override func setUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubviews(infoLabelStackView, actionButton)
        containerStackView.setCustomSpacing(32, after: infoLabelStackView)
        addTarget()
    }

    override func setLayout() {
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        actionButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    override func addTarget() {
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
    }

    //MARK: - Action

    //TODO: - Input output
    @objc
    private func actionButtonDidTap() {
        onTapAction?()
    }
}

extension ParticipantStatusCaseView {

    func reset() {
        infoLabelStackView.reset()
        actionButton.isHidden = true
        actionButton.setTitle("", for: .normal)
        onTapAction = nil
    }

    func configure(
        status: ParticipantStatus,
        model: ParticipantManageModel,
        onTapAction: (() -> Void)? = nil
    ) {
        reset()

        let state = ParticipantManagementStateFactory.make(status: status)
        isHidden = !state.isDetailVisible

        guard state.isDetailVisible else { return }

        infoLabelStackView.configure(items: state.informationItems(for: model))

        if let actionTitle = state.actionTitle {
            actionButton.isHidden = false
            actionButton.setTitle(actionTitle, for: .normal)
            self.onTapAction = onTapAction
        } else {
            actionButton.isHidden = true
        }
    }
}
