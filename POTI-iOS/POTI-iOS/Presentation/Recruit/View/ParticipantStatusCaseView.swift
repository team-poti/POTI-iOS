//
//  ParticipantStatusCaseView.swift
//  POTI-iOS
//
//  Created by Neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantStatusCaseView: BaseView {

    private let containerStackView = UIStackView()
    private let infoLabelStackView = InfoLabelStackView()
    private let actionButton = UIButton()

    private var action: ParticipantManagementAction?
    private var onTapAction: ((ParticipantManagementAction) -> Void)?

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

    @objc
    private func actionButtonDidTap() {
        guard let action else { return }
        onTapAction?(action)
    }
}

extension ParticipantStatusCaseView {

    func reset() {
        infoLabelStackView.reset()
        actionButton.isHidden = true
        actionButton.setTitle("", for: .normal)
        action = nil
        onTapAction = nil
    }

    func configure(
        status: ParticipantStatus,
        model: ParticipantManageModel,
        onTapAction: ((ParticipantManagementAction) -> Void)? = nil
    ) {
        reset()

        let state = ParticipantManagementStateFactory.make(status: status)
        isHidden = !state.isDetailVisible

        guard state.isDetailVisible else { return }

        infoLabelStackView.configure(
            items: state.informationItems(for: model).map {
                (title: $0.title, infos: $0.infos)
            }
        )

        if let action = state.action {
            actionButton.isHidden = false
            actionButton.setTitle(action.title, for: .normal)
            self.action = action
            self.onTapAction = onTapAction
        } else {
            actionButton.isHidden = true
        }
    }
}
