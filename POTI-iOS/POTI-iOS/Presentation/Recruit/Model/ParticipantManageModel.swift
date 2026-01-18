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

//Entity -> Model

extension ManageEntity {
    func toParticipantManageModels() -> [ParticipantManageModel] {
        participants.map { $0.toParticipantManageModel() }
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
                        depositTimeText: $0.depositTime
                    )
                }

        // PAID 상태 + depositInfo 존재 시에만 생성
        let paidInfo: ParticipantManageModel.PaidInfo? =
        (status == .paid ? depositInfo : nil)
                .map {
                    .init(
                        depositorName: $0.depositorName,
                        depositTimeText: $0.depositTime
                    )
                }

        // shippingInfo가 있을 때만 ShipInfo 생성
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

//
//
//extension ParticipantEntity {
//    func toParticipantManageModel() -> ParticipantManageModel {
//        let memberRows: [ParticipantManageModel.MemberRow] = priceInfo.memberPerPrices.map {
//            .init(name: $0.name, price: $0.price)
//        }
//
//        // MARK: - Sections by Status (map 기반)
//
//        // WAIT_PAY_CHECK 상태 + depositInfo 존재 시에만 생성
//        let waitPayCheckInfo: ParticipantManageModel.WaitPayCheckInfo? =
//            (status == .waitPayCheck ? depositInfo : nil)
//                .map {
//                    .init(
//                        depositorName: $0.depositorName,
//                        depositTimeText: $0.depositTime
//                    )
//                }
//
//        // TODO: 서버 상태가 확장되면 여기에서 paidInfo를 채우도록 분기
//        // 현재 Entity에는 paid(입금 완료) 상태/필드가 없어서 우선 nil
//        let paidInfo: ParticipantManageModel.PaidInfo? = nil
//
//        // shippingInfo가 있을 때만 ShipInfo 생성
//        let shipInfo: ParticipantManageModel.ShipInfo? = shippingInfo.map {
//            .init(
//                receiverName: $0.receiverName,
//                addressText: $0.address,
//                phoneText: $0.phone,
//                trackingNumber: $0.trackingNumber ?? ""
//            )
//        }
//
//        return ParticipantManageModel(
//            purchaseId: orderId,
//            profileImage: profileImage ?? "",
//            nickname: nickname,
//            memberTitle: memberNames,
//            participantstatus: status,
//            memberRows: memberRows,
//            shippingText: priceInfo.shippingName,
//            shippingPrice: priceInfo.shippingPrice,
//            totalPrice: priceInfo.totalPrice,
//            waitPayCheckInfo: waitPayCheckInfo,
//            paidInfo: paidInfo,
//            shipInfo: shipInfo
//        )
//    }
//}
