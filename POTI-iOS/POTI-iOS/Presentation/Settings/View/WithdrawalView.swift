//
//  WithdrawalView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class WithdrawalView: BaseView {
    let withdrawButton = SettingsActionButton(title: "탈퇴하기")
    private(set) var selectedReasonCode: String?
    private var reasons: [WithdrawalReasonEntity] = []
    private let titleLabel = UILabel()
    private let reasonStackView = UIStackView()
    private var reasonRows: [WithdrawalReasonRow] = []

    override func setStyle() {
        backgroundColor = .potiWhite
        titleLabel.do {
            $0.text = "탈퇴 사유"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        reasonStackView.axis = .vertical
    }

    override func setUI() {
        withdrawButton.setEnabled(false)
        addSubviews(titleLabel, reasonStackView, withdrawButton)
    }

    func configure(reasons: [WithdrawalReasonEntity]) {
        self.reasons = reasons
        reasonRows.removeAll()
        reasonStackView.arrangedSubviews.forEach {
            reasonStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        reasons.enumerated().forEach { index, reason in
            let row = WithdrawalReasonRow(title: reason.label)
            row.tag = index
            row.addTarget(self, action: #selector(reasonTapped(_:)), for: .touchUpInside)
            reasonRows.append(row)
            reasonStackView.addArrangedSubview(row)
            if index < reasons.count - 1 {
                let divider = UIView().then {
                    $0.backgroundColor = .gray300
                }
                divider.snp.makeConstraints {
                    $0.height.equalTo(2)
                }
                reasonStackView.addArrangedSubview(divider)
            }
        }
        reasonRows.first?.isSelected = true
        selectedReasonCode = reasons.first?.code
        withdrawButton.setEnabled(!reasons.isEmpty)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        reasonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        withdrawButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }

    @objc private func reasonTapped(_ sender: WithdrawalReasonRow) {
        reasonRows.forEach { $0.isSelected = $0 === sender }
        selectedReasonCode = reasons[sender.tag].code
        withdrawButton.setEnabled(true)
    }
}
