//
//  ParticipantManageSummaryCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantManageSummaryCell: UITableViewCell {
    
    let mockParticipantManageModel = ParticipantManageModel(
            purchaseId: 103,
            profileImage: "https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F311%2F2025%2F08%2F18%2F0001905912_001_20250818141307379.jpg&type=a340",
            nickname: "안유진사랑해",
            memberTitle: ["IVE 포카 공동구매"],
            participantstatus: .waitPayCheck,   // 임의 상태
            memberRows: [
                ParticipantManageModel.MemberRow(name: "유진 포카 A", price: 5000),
                ParticipantManageModel.MemberRow(name: "유진 포카 B", price: 5000)
            ],
            shippingText: "준등기",
            shippingPrice: 1500,
            totalPrice: 11500,
            waitPayCheckInfo: ParticipantManageModel.WaitPayCheckInfo(
                depositorName: "짱나연",
                depositTimeText: "2026-01-15 22:56:00"
            ),
            paidInfo: ParticipantManageModel.PaidInfo(
                depositorName: "짱나연",
                depositTimeText: "2026-01-15 22:56:00"
            ),
            shipInfo: nil,
            completedInfo: nil
        )
    
    static let identifier = "ParticipantManageSummaryCell"
    
    var onTapStatusAction: ((ParticipantManageModel) -> Void)?
    var onTapToggle: (() -> Void)?
    
    private let totalStackView = IconStackView(
        iconName: "icn-priceAngle",
        title: "총 입금 금액",
        price: 12800,
        fontSizeCase: .large
    )
    private let participantCaseView = ParticipantStatusCaseView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setStyle()
        setUI()
        setLayout()
        participantCaseView.configure(status: .waitPayCheck, model: mockParticipantManageModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapToggle = nil
        onTapStatusAction = nil
    }
    
    // MARK: - UI Component

    private let participantMemberLabel = UILabel()
    private let statusLabel = UILabel()
    private let toggleButton = UIButton()
    private let divideView = DivideView()
    
    //MARK: - Custom Method
    
    private func setStyle() {
        participantMemberLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        statusLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        toggleButton.do {
            $0.setImage(.icnArrowDownLg, for: .normal)
        }
    }
    
    func setUI() {
        contentView.addSubviews(
            participantMemberLabel,
            statusLabel,
            toggleButton,
            divideView
        )
        
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
        //TODO: - 위치 어디로 넣지
        
    }
    
    func setLayout() {
        divideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        participantMemberLabel.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(participantMemberLabel)
        }
        statusLabel.snp.makeConstraints {
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-8)
            $0.centerY.equalTo(participantMemberLabel)
        }
    }
}

extension ParticipantManageSummaryCell {
    /// VC에서 사용하는 API (펼침 여부에 따라 chevron 업데이트)
    func configure(model: ParticipantManageModel, isExpanded: Bool) {
        participantMemberLabel.text = model.memberTitle.joined(separator: ", ")

        statusLabel.text = model.participantstatus.badgeText
        statusLabel.textColor = model.participantstatus.badgeColor

        toggleButton.setImage(isExpanded ? .icnArrowUpLg : .icnArrowDownLg, for: .normal)

        
        participantCaseView.configure(
            status: model.participantstatus,
            model: model,
            onTapAction: { [weak self] in
                guard let self else { return }
                self.onTapStatusAction?(model)
            }
        )
    }
    
    @objc private func didTapToggle() {
        onTapToggle?()
    }
}
