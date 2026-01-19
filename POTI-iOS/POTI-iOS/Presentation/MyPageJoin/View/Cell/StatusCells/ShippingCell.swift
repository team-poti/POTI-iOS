//
//  ShippingCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit
import SnapKit

final class ShippingCell: UITableViewCell {

    static let identifier = "ShippingCell"

    private let depositStatusRowView = StatusRowView()
    private let joinShipInfoView = JoinShipInfoView()
    private let joinTrackingNumberView = JoinTrackingNumberView()
    private let completeButton = PotiBottomButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setLayout()
        self.backgroundColor = .potiWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubviews(
            depositStatusRowView,
            joinShipInfoView,
            joinTrackingNumberView,
            completeButton
        )
    }

    private func setLayout() {
        depositStatusRowView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(16)
        }
        joinShipInfoView.snp.makeConstraints {
            $0.top.equalTo(depositStatusRowView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        joinTrackingNumberView.snp.makeConstraints {
            $0.top.equalTo(joinShipInfoView.snp.bottom).offset(-4)
            $0.horizontalEdges.equalToSuperview()
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(joinTrackingNumberView.snp.bottom).offset(77)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(model: MyPageJoinModel) {
        depositStatusRowView.configure(depositInfo: model.paymentInfo)
        joinShipInfoView.configure(model: model)
        joinTrackingNumberView.configure(model: model)
        completeButton.color = .primaryMain
        completeButton.text = "배송을 받았어요"
        completeButton.isDisabled = false
    }
}
