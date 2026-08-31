//
//  ParticipantOrderStatus+Presentation.swift
//  POTI-iOS
//
//  Created by Neon on 8/30/26.
//

import UIKit

extension ParticipantOrderStatus {
    var badgeText: String {
        switch self {
        case .waitPay: return "입금 대기"
        case .waitPayCheck: return "입금 확인중"
        case .paid: return "입금 완료"
        case .shipped: return "배송 시작"
        case .delivered: return "배송 완료"
        case .unknown: return "상태 확인 중"
        }
    }

    var badgeColor: UIColor {
        switch self {
        case .waitPay, .unknown:
            return .gray700
        case .paid, .delivered:
            return .poti600
        case .waitPayCheck:
            return .sementicRed
        case .shipped:
            return .poti600
        }
    }
}
