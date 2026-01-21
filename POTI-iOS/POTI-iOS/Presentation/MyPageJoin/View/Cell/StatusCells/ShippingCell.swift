//
//  ShippingCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit

final class ShippingCell: UITableViewCell {
    
    private let depositStatusRowView = StatusRowView()
    private let joinShipInfoView = JoinShipInfoView()
    private let joinTrackingNumberView = JoinTrackingNumberView()
    
    var onTapCompleteButton: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .potiWhite
    }
    
    private func setUI() {
        selectionStyle = .none
        contentView.addSubviews(
            depositStatusRowView,
            joinShipInfoView,
            joinTrackingNumberView
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
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(model: MyPageJoinModel) {
        depositStatusRowView.configure(depositInfo: model.paymentInfo)
        joinShipInfoView.configure(model: model)
        joinTrackingNumberView.configure(model: model)
    }
}
