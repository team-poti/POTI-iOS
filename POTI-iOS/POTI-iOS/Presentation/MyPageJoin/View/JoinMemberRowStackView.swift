//
//  JoinMemberRowStackView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class JoinMemberRowStackView: BaseView {
    
    // MARK: - UI Components
    
    private let memberListStackView = UIStackView()
    
    // MARK: - Custom Method
    
    override func setStyle() {
        memberListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill //반대축으로 꽉 채우기 (현 스택은 vertical이니까 horizontal로 fill
            $0.distribution = .fill
        }
    }
    
    override func setUI() {
        self.addSubview(
            memberListStackView
        )
    }
    
    override func setLayout() {
        memberListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension JoinMemberRowStackView {
    func reset() {
        memberListStackView.arrangedSubviews.forEach {
            memberListStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func configure(model: ParticipantManageModel) {
        configure(rows: model.memberRows.map { ($0.name, $0.price) })
    }
    
    func configure(rows: [(name: String, price: Int)]) {
        reset()
        rows.forEach { row in
            let iconStackView = IconStackView(
                iconName: "icn-member",
                title: row.name,
                price: row.price,
                fontSizeCase: .small
            )
            memberListStackView.addArrangedSubview(iconStackView)
        }
    }
}
