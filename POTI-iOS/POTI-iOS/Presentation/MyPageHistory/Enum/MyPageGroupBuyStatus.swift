//
//  MyPageGroupBuyStatus.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import UIKit

enum MyPageGroupBuyStatus: String {
    case recruiting = "RECRUITING"
    case closed = "CLOSED"
    case paymentDone = "PAYMENT_DONE"
    case shipping = "SHIPPING"
    case delivered = "DELIVERED"

    var title: String {
        switch self {
        case .recruiting: return "모집 중"
        case .closed: return "모집 완료"
        case .paymentDone: return "입금 완료"
        case .shipping: return "배송 시작"
        case .delivered: return "배송 완료"
        }
    }

    var color: UIColor {
        switch self {
        case .recruiting:
            return .sementicRed
        case .closed, .paymentDone, .shipping:
            return .poti600
        case .delivered:
            return .gray700
        }
    }
}
