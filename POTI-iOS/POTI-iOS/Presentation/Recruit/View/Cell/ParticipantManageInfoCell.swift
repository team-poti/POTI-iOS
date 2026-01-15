//
//  ParticipantManageInfoCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantManageInfoCell: UITableViewCell {
    
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
    
    static let identifier = "ParticipantManageInfoCell"
    
    var onTapStatusAction: ((ParticipantManageModel) -> Void)?
    
    private let totalStackView = IconStackView(
        iconName: "icn-priceAngle",
        title: "총 입금 금액",
        price: 12800,
        fontSizeCase: .large
    )
    private let participantCaseView = ParticipantStatusCaseView() // TODO: - 이따 snp , add 하기
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        setStyle()
        setUI()
        setLayout()
        configure(model: mockParticipantManageModel)
        participantCaseView.configure(status: .waitPayCheck, model: mockParticipantManageModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberRowStackView.reset()
        // 재사용 시 이전 데이터 잔상 방지
        // (MemberRowStackView에 reset()이 있으면 여기서 호출)
    }
    
    // MARK: - UI Component
    
    private let grayBackgroundView = UIView()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let depositLabel = UILabel()
    private let memberRowStackView = MemberRowStackView()
    private let shippingStackView = IconStackView(iconName: "icn-delivery", title: "", price: 0, fontSizeCase: .small)
    private let divideTopView = UIView()
    private let divideBottomView = UIView()
    
    //MARK: - Custom Method
    
    private func setStyle() {
        
        grayBackgroundView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 12
        }
        
        profileImageView.do {
            let url = URL(string: mockParticipantManageModel.profileImage)
            $0.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            )
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
        
        nicknameLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
            $0.text = mockParticipantManageModel.nickname
        }
        
        divideTopView.do {
            $0.backgroundColor = .gray300
        }
        
        depositLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
            $0.text = "입금 금액"
        }
        
        divideBottomView.do {
            $0.backgroundColor = .gray300
        }
    }
    
    func setUI() {
        
        contentView.addSubviews(
            grayBackgroundView,
            profileImageView,
            nicknameLabel,
            divideTopView,
            depositLabel,
            memberRowStackView,
            shippingStackView,
            divideBottomView,
            totalStackView,
            participantCaseView
        )
        
    }
    
    func setLayout() {
        grayBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(profileImageView)
        }
        divideTopView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        depositLabel.snp.makeConstraints {
            $0.top.equalTo(divideTopView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        memberRowStackView.snp.makeConstraints {
            $0.top.equalTo(depositLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        shippingStackView.snp.makeConstraints {
            $0.top.equalTo(memberRowStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        divideBottomView.snp.makeConstraints {
            $0.top.equalTo(shippingStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        totalStackView.snp.makeConstraints {
            $0.top.equalTo(divideBottomView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        participantCaseView.snp.makeConstraints {
            $0.top.equalTo(totalStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

extension ParticipantManageInfoCell {
    func configure(model: ParticipantManageModel) {
        
        nicknameLabel.text = model.nickname
        if let url = URL(string: model.profileImage) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }

        // 멤버 rows
        memberRowStackView.configure(model: model)

        // 배송/총액
        shippingStackView.configure(
            title: model.shippingText,
            price: model.shippingPrice
        )
        
        totalStackView.configure(title: "총 입금 금액", price: model.totalPrice)

        participantCaseView.configure(
            status: model.participantstatus,
            model: model,
            onTapAction: { [weak self] in
                guard let self else { return }
                self.onTapStatusAction?(model)
            }
        )
    }
}
#Preview {
    ParticipantManageInfoCell()
}
