//
//  ParticipantOrderStatusDomain.swift
//  POTI-iOS
//
//  Created by Neon on 8/30/26.
//

/// 서버가 전달하는 참여 주문 상태.
///
/// 화면 표현(색상, 문구, 이미지)은 Presentation 확장에서 담당한다.
enum ParticipantOrderStatus: String, Equatable {
    case waitPay = "WAIT_PAY"
    case waitPayCheck = "WAIT_PAY_CHECK"
    case paid = "PAID"
    case shipped = "SHIPPED"
    case delivered = "DELIVERED"
    case unknown = "UNKNOWN"

    init(serverValue: String) {
        self = ParticipantOrderStatus(rawValue: serverValue) ?? .unknown
    }
}
