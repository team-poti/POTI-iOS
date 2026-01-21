//
//  MemberRowStackView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class MemberRowStackView: BaseView {
    
    // MARK: - UI Components
    
    private let memberListStackView = UIStackView()
    
    // MARK: - Custom Method
    
    override func setStyle() {
        memberListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
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

extension MemberRowStackView {
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
