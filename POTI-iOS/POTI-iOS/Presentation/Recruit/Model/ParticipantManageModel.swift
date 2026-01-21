//
//  ParticipantManageModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/14/26.
//

struct ParticipantManageModel: Hashable {
    let purchaseId: Int
    let profileImage: String // 프로필 이미지
    let nickname: String // 닉네임
    let memberTitle: [String]
    let participantstatus: ParticipantStatus // 상태 (입금 확인 중 , 배송 완료..)
    let memberRows: [MemberRow]
    let shippingText: String // 준등기
    let shippingPrice: Int // 1500
    let totalPrice: Int // 총 입금 금액
    let waitPayCheckInfo: WaitPayCheckInfo? // nil이면 숨김
    let paidInfo: PaidInfo? // nil이면 숨김
    let shipInfo: ShipInfo? // nil이면 숨김

    struct MemberRow: Hashable {
        let name: String
        let price: Int
    }

    struct WaitPayCheckInfo: Hashable { // 입금 확인 중 (status가 waitPayCheck)
        let depositorName: String
        let depositTimeText: String
    }
    struct PaidInfo: Hashable {
        let depositorName: String
        let depositTimeText: String
    }
    struct ShipInfo: Hashable {
        let receiverName: String
        let addressText: String
        let phoneText: String // "배송 시작"
        let trackingNumber: String // 운송장 번호 (nil 로 받고 내가 post)
    }
}

extension ParticipantManageModel {

    /// ParticipantManageViewCell 에서 사용
    var participantManageViewCellModel: ParticipantManageViewCell.Model {
        .init(
            memberNamesText: memberTitle,
            depositorNameText: depositorNameText,
            addressText: shipInfo?.addressText ?? "",
            phoneText: shipInfo?.phoneText ?? "",
            shippingText: shippingText,
            totalPrice: totalPrice,
            depositState: participantstatus
        )
    }

    /// 상태에 따라 입금자명 텍스트를 결정
    private var depositorNameText: String {
        if let waitPayCheckInfo {
            return waitPayCheckInfo.depositorName
        }

        if let paidInfo {
            return paidInfo.depositorName
        }

        return ""
    }
}


extension ParticipantEntity {
    func toParticipantManageModel() -> ParticipantManageModel {
        let memberRows: [ParticipantManageModel.MemberRow] = priceInfo.memberPerPrices.map {
            .init(name: $0.name, price: $0.price)
        }
        
        let waitPayCheckInfo: ParticipantManageModel.WaitPayCheckInfo? = depositInfo.map {
                    .init(
                        depositorName: $0.depositorName,
                        depositTimeText: $0.depositTime.formattedDateString()
                    )
                }

        let paidInfo: ParticipantManageModel.PaidInfo? = depositInfo.map {
            .init(depositorName: $0.depositorName,
                  depositTimeText: $0.depositTime.formattedDateString()
            )
        }

        let shipInfo: ParticipantManageModel.ShipInfo? = shippingInfo.map {
            .init(
                receiverName: $0.receiverName,
                addressText: $0.address,
                phoneText: $0.phone,
                trackingNumber: $0.trackingNumber ?? ""
            )
        }

        return ParticipantManageModel(
            purchaseId: orderId,
            profileImage: profileImage ?? "",
            nickname: nickname,
            memberTitle: memberNames,
            participantstatus: status,
            memberRows: memberRows,
            shippingText: priceInfo.shippingName,
            shippingPrice: priceInfo.shippingPrice,
            totalPrice: priceInfo.totalPrice,
            waitPayCheckInfo: waitPayCheckInfo,
            paidInfo: paidInfo,
            shipInfo: shipInfo
        )
    }
}
