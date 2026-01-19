//
//  JoinShipInfoView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then


/// 배송 정보
///

final class JoinShipInfoView: BaseView {

    private let shipInfoView = JoinParticipantInfoLabelView()
    private let divideView = UIView()
    private let joinShipIconInfoView = JoinIconStackView(
        iconName: "icn-delivery",
        title: ""
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setStyle() {
        divideView.backgroundColor = .gray100
    }

    override func setUI() {
        addSubviews(
            divideView,
            shipInfoView,
            joinShipIconInfoView
        )
    }

    override func setLayout() {
        divideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }

        shipInfoView.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        joinShipIconInfoView.snp.makeConstraints {
            $0.top.equalTo(shipInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(shipInfoView)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    
    func configure(model: MyPageJoinModel) {
        shipInfoView.configure(
            title: "배송 정보",
            infos: [
                model.shippingInfo.receiver,
                model.shippingInfo.address,
                model.shippingInfo.phone
            ]
        )
        joinShipIconInfoView.configure(title: model.shippingInfo.shippingMethod)
    }
}
