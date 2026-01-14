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
    let startShipInfo: StartShipInfo? // nil이면 숨김
    let completedInfo: CompletedInfo? // nil이면 숨김

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
        let buttonTitle: String // "입금 완료"
    }
    struct StartShipInfo: Hashable {
        let receiverName: String
        let addressText: String
        let phoneText: String // "배송 시작"
        let trackingNumber: String // 운송장 번호 (nil 로 받고 내가 post)
    }
    struct CompletedInfo: Hashable {
        let depositorName: String
        let depositTimeText: String
        let buttonTitle: String // "배송 완료"
    }
}
