//
//  ParticipantStatus.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import UIKit

enum ParticipantStatus {
    case waitRecruit
    case waitPay
    case waitPayCheck
    case paid
    case startShip
    case completed

    var badgeText: String {
        switch self {
        case .waitRecruit: return "모집 대기"
        case .waitPay: return "입금 대기"
        case .waitPayCheck: return "입금 확인 중"
        case .paid: return "입금 완료"
        case .startShip: return "배송 시작"
        case .completed: return "배송 완료"
        }
    }
    
    var badgeColor: UIColor {
            switch self {
            case .waitRecruit, .waitPayCheck:
                return .sementicRed
            case .waitPay, .completed:
                return .gray700
            case .paid, .startShip:
                return .poti600
            }
        }
}
