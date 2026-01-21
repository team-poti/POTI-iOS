//
//  MyJoinDepositInfoCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then

/// 입금 정보!!!!!!!! 모집자 !!!!!
final class MyJoinDepositInfoCell: UITableViewCell {
    
    var onTapStatusAction: ((ParticipantManageModel) -> Void)?
    var onTapToggle: (() -> Void)?
    /// `.paid` 상태에서 보이는 "송장 번호 입력" 버튼 탭 콜백 << - 추후 수정 예정
    var onTapEnterTrackingNumber: ((ParticipantManageModel) -> Void)?
    
    private let totalStackView = IconStackView(
        iconName: "icn-priceAngle",
        title: "총 입금 금액",
        price: 12800,
        fontSizeCase: .large
    )
    private let divideView = DivideView()
    private let bottomDivideView = DivideView()
    
    // MARK: - UI Component
    
    private let depositLabel = UILabel()
    private let memberRowStackView = JoinMemberRowStackView()
    private let shippingStackView = IconStackView(iconName: "icn-delivery", title: "", price: 0, fontSizeCase: .small)
    private let depositStatusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapToggle = nil
        onTapStatusAction = nil
        onTapEnterTrackingNumber = nil
        memberRowStackView.reset()
    }
    
    //MARK: - Custom Method
    
    private func setStyle() {
        
        depositLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
            $0.text = "입금 정보"
        }
    }
    
    private func setUI() {
        contentView.addSubviews (
            depositLabel,
            memberRowStackView,
            shippingStackView,
            divideView,
            totalStackView
        )
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        depositLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        memberRowStackView.snp.makeConstraints {
            $0.top.equalTo(depositLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        shippingStackView.snp.makeConstraints {
            $0.top.equalTo(memberRowStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(shippingStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        totalStackView.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MyJoinDepositInfoCell {
    func configure(model: MyPageJoinModel)
    {
        memberRowStackView.configure(
            rows: model.memberPayments.map { (name: $0.memberName, price: $0.price) }
        )
        shippingStackView.configure(
            title: model.shippingInfo.shippingMethod,
            price: model.paymentInfo.shippingFee
        )
        totalStackView.configure(title: "총 입금 금액", price: model.paymentInfo.totalAmount)
    }
}
