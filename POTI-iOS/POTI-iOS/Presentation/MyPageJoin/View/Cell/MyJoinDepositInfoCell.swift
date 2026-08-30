//
//  MyJoinDepositInfoCell.swift
//  POTI-iOS
//
//  Created by Neon on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class MyJoinDepositInfoCell: UITableViewCell {
    
    private let totalStackView = IconStackView(
        iconName: "icn-priceAngle",
        title: "총 입금 금액",
        price: 12800,
        fontSizeCase: .large
    )
    private let divideView = DivideView()
    
    // MARK: - UI Component
    
    private let depositLabel = UILabel()
    private let memberRowStackView = JoinMemberRowStackView()
    private let shippingStackView = IconStackView(iconName: "icn-delivery", title: "", price: 0, fontSizeCase: .small)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        contentView.backgroundColor = .potiWhite
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberRowStackView.reset()
    }
    
    //MARK: - Custom Method
    
    private func setStyle() {
        
        depositLabel.do {
            $0.font = PotiFontManager.body16sb.font
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
    func configure(state: MyJoinDepositState) {
        memberRowStackView.configure(
            rows: state.memberRows.map { (name: $0.name, price: $0.price) }
        )
        
        shippingStackView.configure(
            title: state.shippingMethod,
            price: state.shippingFee
        )
        
        totalStackView.configure(
            title: "총 입금 금액",
            price: state.totalAmount
        )
    }
}
