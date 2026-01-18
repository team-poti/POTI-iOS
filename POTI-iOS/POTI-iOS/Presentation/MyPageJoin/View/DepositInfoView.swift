//
//  DepositInfoView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

/// 복사 아래 밑줄!!!!!!!!!!!!!!!!!
import UIKit

import SnapKit
import Then

final class DepositInfoView: BaseView {

    // MARK: - UI

    private let accountContainerView = UIView()
    private let accountLabel = UILabel()
    private let copyButton = UIButton()

    private let deadlineContainerView = UIView()
    private let deadlineLabel = UILabel()

    private let statusLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {

        accountContainerView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }

        accountLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }

        copyButton.do {
            $0.setTitle("복사", for: .normal)
            $0.setTitleColor(.gray700, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
        }
        copyButton.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)

        deadlineContainerView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }

        deadlineLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14m.font
        }
        
        statusLabel.do {
            $0.font = PotiFontManager.body16m.font
        }

        addSubviews(
            accountContainerView,
            deadlineContainerView,
            statusLabel
        )

        accountContainerView.addSubviews(accountLabel, copyButton)
        deadlineContainerView.addSubview(deadlineLabel)
    }

    // MARK: - Layout

    private func setupLayout() {
        accountContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }

        accountLabel.snp.makeConstraints {
            $0.leading.equalTo(accountContainerView.snp.leading).offset(16)
            $0.centerY.equalTo(accountContainerView)
        }

        copyButton.snp.makeConstraints {
            $0.trailing.equalTo(accountContainerView.snp.trailing).inset(16)
            $0.centerY.equalTo(accountContainerView)
        }

        deadlineContainerView.snp.makeConstraints {
            $0.top.equalTo(accountContainerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }

        deadlineLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(16)
            $0.centerY.equalTo(deadlineContainerView)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineContainerView.snp.bottom).offset(28)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func configure(model: DepositInfoViewData) {
        accountLabel.text = model.accountText
        deadlineLabel.text = model.deadlineText
        statusLabel.text = model.statusText
        statusLabel.textColor = model.statusColor
    }
    
    @objc private func didTapCopy() {
        guard let text = accountLabel.text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }
}

extension MyPageJoinModel {
    func toDepositInfoViewData() -> DepositInfoViewData {
        let accountText: String = {
            guard let bank = paymentInfo.bank,
                  let account = paymentInfo.accountNumber
            else { return "" }
            return "\(bank) \(account)"
        }()

        let deadlineText: String = {
            guard let deadline = paymentInfo.depositDeadline?.formattedDateString() else { return "" }
            return "\(deadline) 까지"
        }()

        
        let (statusText, statusColor): (String, UIColor) = {
            switch paymentInfo.depositStatus {
            case .waiting:
                return ("입금 대기", .sementicRed)
            case .completed:
                return ("입금 완료", .gray700)
            case .shipped:
                return ("입금 확인중", .poti600)
            }
        }()

        return DepositInfoViewData(
            accountText: accountText,
            deadlineText: deadlineText,
            statusText: statusText,
            statusColor: statusColor
        )
    }
}

#Preview {
    let view = DepositInfoView()
    
    let mock = DepositInfoViewData(
        accountText: "카카오뱅크 3333-19-1234123",
        deadlineText: "2026-01-01 23:59 까지",
        statusText: "입금 대기",
        statusColor: .sementicRed //0119 !!!!! TODO : - 모델 연결하기
    )
    
    view.configure(model: mock)
    return view
}
