//
//  RegisterShippingView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

final class RegisterShippingView: BaseView {
    
    private let titleLabel = UILabel()
    private let rowsStackView = UIStackView()
    private let bottomBoxView = UIView()

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.text = "배송 설정"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        rowsStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        bottomBoxView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, rowsStackView, bottomBoxView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }

        rowsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        bottomBoxView.snp.makeConstraints {
            $0.top.equalTo(rowsStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(9)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Custom Method

    func configure(options: [(name: String, price: Int)]) {
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        options.forEach { option in
            let row = ShippingRowView()
            row.configure(name: option.name, price: option.price)
            rowsStackView.addArrangedSubview(row)
        }
    }

}

#Preview {
    let view = RegisterShippingView()
    view.configure(options: [
        (name: "일반택배", price: 4000),
        (name: "준등기", price: 1800)
    ])
    return view
}
