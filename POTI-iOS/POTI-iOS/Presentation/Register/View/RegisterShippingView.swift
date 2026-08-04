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
    private var selectedIndices: Set<Int> = []
    
    struct ShippingRequest {
        let deliveryMethodId: Int
        let price: Int
    }

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
            $0.top.equalToSuperview().inset(24)
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
        selectedIndices = [0]

        for (index, option) in options.enumerated() {
            let row = ShippingRowView()
            row.configure(name: option.name, price: option.price)
            row.setSelected(selectedIndices.contains(index))
            row.onTap = { [weak self] in
                guard let self = self else { return }
                if self.selectedIndices.contains(index) {
                    if self.selectedIndices.count == 1 {
                        return
                    }
                    self.selectedIndices.remove(index)
                } else {
                    self.selectedIndices.insert(index)
                }
                for (i, view) in self.rowsStackView.arrangedSubviews.enumerated() {
                    if let shippingRow = view as? ShippingRowView {
                        shippingRow.setSelected(self.selectedIndices.contains(i))
                    }
                }
            }
            rowsStackView.addArrangedSubview(row)
        }
    }
    
    func collectSelectedShippings() -> [ShippingRequest] {
        var result: [ShippingRequest] = []

        for index in selectedIndices.sorted() {
            switch index {
            case 0:
                result.append(
                    ShippingRequest(deliveryMethodId: 1, price: 4000)
                )
            case 1:
                result.append(
                    ShippingRequest(deliveryMethodId: 2, price: 1800)
                )
            default:
                break
            }
        }

        return result
    }
}
