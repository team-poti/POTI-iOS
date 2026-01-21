///
//  DepositInfoView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

//TODO: -복사 아래 밑줄!!!!!!!!0120
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        
        accountContainerView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
        
        accountLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }
        
        copyButton.do {
            let underlineAttributes: [NSAttributedString.Key: Any] = [
                .font: PotiFontManager.body14m.font,
                .foregroundColor: UIColor.gray700,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributedTitle = NSAttributedString(
                string: "복사",
                attributes: underlineAttributes
            )
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        deadlineContainerView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
        
        deadlineLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14m.font
        }
        
        statusLabel.do {
            $0.font = PotiFontManager.body16m.font
        }
    }
    
    override func setUI() {
        addSubviews(
            accountContainerView,
            deadlineContainerView,
            statusLabel
        )
        accountContainerView.addSubviews(accountLabel, copyButton)
        deadlineContainerView.addSubview(deadlineLabel)
    }
    
    override func setLayout() {
        accountContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(deadlineContainerView).inset(16)
            $0.centerY.equalTo(deadlineContainerView)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineContainerView.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func addTarget() {
        copyButton.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
    }
    
    func configure(model: MyPageJoinModel) {
        accountLabel.text = model.depositAccountText
        deadlineLabel.text = model.depositDeadlineText
        statusLabel.text = model.depositStatusDisplay.text
        statusLabel.textColor = model.depositStatusDisplay.color
    }
    
    @objc private func didTapCopy() {
        guard let text = accountLabel.text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }
}

extension MyPageJoinModel {
    
    var depositAccountText: String {
        guard
            let bank = paymentInfo.bank,
            let account = paymentInfo.accountNumber
        else { return "" }
        return "\(bank) \(account)"
    }
    
    var depositDeadlineText: String {
        guard let deadline = paymentInfo.depositDeadline?.formattedDateString()
        else { return "" }
        return "\(deadline) 까지"
    }
    
    var depositStatusDisplay: (text: String, color: UIColor) {
        switch paymentInfo.depositStatus {
        case .waiting:
            return ("입금 대기", .sementicRed)
        case .completed:
            return ("입금 완료", .gray700)
        case .shipped:
            return ("입금 확인중", .poti600)
        }
    }
}
