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
    static let reasons = [
        "원하는 굿즈를 찾기 어려워요.",
        "분철 모집 또는 참여 과정이 불편해요.",
        "필요한 기능이 부족해요.",
        "오류나 버그를 자주 경험했어요.",
        "다른 서비스를 이용하고 있어요.",
        "이용 빈도가 낮아요.",
        "기타"
    ]

    let withdrawButton = SettingsActionButton(title: "탈퇴하기")
    private(set) var selectedReason: String?
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
        Self.reasons.enumerated().forEach { index, reason in
            let row = WithdrawalReasonRow(title: reason)
            row.tag = index
            row.addTarget(self, action: #selector(reasonTapped(_:)), for: .touchUpInside)
            reasonRows.append(row)
            reasonStackView.addArrangedSubview(row)
            if index < Self.reasons.count - 1 {
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
        selectedReason = Self.reasons.first
        withdrawButton.setEnabled(true)
        addSubviews(titleLabel, reasonStackView, withdrawButton)
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
        selectedReason = Self.reasons[sender.tag]
        withdrawButton.setEnabled(true)
    }
}
