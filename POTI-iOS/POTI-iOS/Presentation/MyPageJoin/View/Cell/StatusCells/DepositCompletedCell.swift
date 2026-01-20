//
//  DepositCompletedCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit
import SnapKit

final class DepositCompletedCell: UITableViewCell {
    
    private let depositStatusRowView = StatusRowView()
    private let joinShipInfoView = JoinShipInfoView()
    private let shipStatusRowView = StatusRowView()
    
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
        contentView.addSubviews (
            depositStatusRowView,
            joinShipInfoView,
            shipStatusRowView
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
        shipStatusRowView.snp.makeConstraints {
            $0.top.equalTo(joinShipInfoView.snp.bottom)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configure(model: MyPageJoinModel) {
        depositStatusRowView.configure(depositInfo: model.paymentInfo)
        shipStatusRowView.configure(shippingInfo: model.shippingInfo)
        joinShipInfoView.configure(model: model)
    }
}
