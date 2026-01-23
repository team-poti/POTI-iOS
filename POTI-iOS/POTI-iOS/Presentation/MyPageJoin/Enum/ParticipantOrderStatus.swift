//
//  ParticipantOrderStatus.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import UIKit

enum ParticipantOrderStatus: String {
    case  waitPay = "WAIT_PAY"
    case  waitPayCheck = "WAIT_PAY_CHECK"
    case  paid = "PAID"
    case  ready = "READY"
    case  shipped = "SHIPPED"
    case  delivered = "DELIVERED"
    
    var badgeText: String {
        switch self {
        case .waitPay: return "입금 대기"
        case .waitPayCheck: return "입금 확인중"
        case .paid: return "입금 완료"
        case .ready: return "배송 대기"
        case .shipped: return "배송 시작"
        case .delivered: return "배송 완료"
        }
    }
    
    var badgeColor: UIColor {
        switch self {
        case .waitPay, .ready:
            return .sementicRed
        case .paid, .delivered:
            return .gray700
        case .waitPayCheck, .shipped:
            return .poti600
        }
    }
}
