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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components

    private let memberListStackView = UIStackView()

    // MARK: - Custom Method
    
    override func setStyle() {
        memberListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill //반대축으로 꽉 채우기 (현 스택은 vertical이니까 horizontal로 fill
            $0.distribution = .fillEqually // 스택 방향 공간 분배
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
    func configure(model: ParticipantManageModel) {
        configure(rows: model.memberRows.map { ($0.name, $0.price) })
    }

    func configure(rows: [(name: String, price: Int)]) {
        memberListStackView.arrangedSubviews.forEach {
            memberListStackView.removeArrangedSubview($0)
            $0.removeFromSuperview() //기존 row 삭제해주고
        }
        
        rows.forEach { row in // row 추가해주기
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

#Preview {
    let view = MemberRowStackView()
    view.configure(rows: [
        (name: "유진", price: 5000),
        (name: "가을", price: 6000),
        (name: "레이", price: 7000)
    ])
    return view
}
