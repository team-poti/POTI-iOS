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

final class JoinShipInfoView: BaseView {
    private let shipInfoView = JoinParticipantInfoLabelView()
    private lazy var joinShipIconInfoView = JoinIconStackView(
        iconName: "icn-delivery",
        title: model.shippingInfo.shippingMethod
        )
    private let divideView = UIView()
    
    
    private let model = MyPageJoinModel(
        participationId: 1,
        imageUrlString: "",
        artistName: "아이브",
        title: "러브 다이브",
        postStatus: .shipping,
        orderStatus: .waiting,
        statusMessage: "뭐지이건",
        memberPayments: [
            .init(memberName: "장원영", price: 7500),
            .init(memberName: "안유진", price: 5000)
        ],
        paymentInfo: .init(
            shippingFee: 3500,
            totalAmount: 16500,
            depositStatus: .waiting,
            bank: "카카오뱅크",
            accountNumber: "3333-19-1234123",
            depositDeadline: "2026-01-01 23:59 까지"
        ),
        shippingInfo: .init(
            shippingMethod: "일반택배",
            receiver: "홍길동",
            zipcode: "12345",
            address: "서울시 강남구 테헤란로 123",
            phone: "010-1234-5678",
            carrier: "대한통운",
            trackingNumber: "6824910234",
            shippingStatus: .shipped
        )
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shipInfoView.configure(
            title: "배송 정보",
            infos: [
                model.shippingInfo.receiver,
                model.shippingInfo.address,
                model.shippingInfo.phone
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        divideView.do {
            $0.backgroundColor = .gray100
        }
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
        }
        shipInfoView.snp.makeConstraints {
            $0.top.equalTo(divideView).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
        joinShipIconInfoView.snp.makeConstraints {
            $0.top.equalTo(shipInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

#Preview {
    JoinShipInfoView()
}
