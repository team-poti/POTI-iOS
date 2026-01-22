//
//  ParticipantStatus.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import UIKit

/*
 WAIT_PAY, // 입금 대기
 WAIT_PAY_CHECK, //입금 확인 대기
 PAID, //입금 완료
 READY, //배송 대기
 SHIPPED, //배송 시작
 DELIVERED //배송 완료
 case .waitRecruit: return "모집 대기"
 case .waitPay: return "입금 대기"
 case .waitPayCheck: return "입금 확인중"
 case .paid: return "입금 완료"
 case .startShip: return "배송 시작"
 case .completed: return "배송 완료"
 }
 
 case .waitPay: return "모집 대기"
 case .waitPayCheck: return "입금 대기"
 case .paid: return "입금 확인중"
 case .ready: return "입금 완료"
 case .shipped: return "배송 시작"
 case .delivered: return "배송 완료"
 }
 */

enum ParticipantOrderStatus: String {
    case waitPay = "WAIT_PAY"
    case waitPayCheck = "WAIT_PAY_CHECK"
    case paid = "PAID"
    case ready = "READY"
    case shipped = "SHIPPED"
    case delivered = "DELIVERED"
    
    func statusText(role: UserRole) -> String {
        switch self {
        case .waitPay:
            switch role {
            case .host:
                return "참여자들을 기다리고 있어요"
            case .participant:
                return "다른 참여자들을 기다리고 있어요"
            }
            
        case .waitPayCheck:
            switch role {
            case .host:
                return "입금을 기다리는 중이에요. 입금 확인을 기다리는 참여자가 있어요"
            case .participant:
                return "지금 입금해주세요! 모집자가 입금 내역을 확인하고 있어요"
            }
            
        case .paid:
            switch role {
            case .host:
                return "입금 확인을 기다리는 참여자가 있어요"
            case .participant:
                return "모집자가 입금 내역을 확인하고 있어요"
            }
            
        case .ready:
            switch role {
            case .host:
                return "배송을 기다리는 참여자가 있어요"
            case .participant:
                return "모집자가 배송을 준비 중이에요"
            }
            
        case .shipped:
            switch role {
            case .host:
                return "배송을 시작했어요"
            case .participant:
                return "모집자가 배송을 시작했어요"
            }
        case .delivered:
            switch role {
            case .host:
                return "거래가 종료되었어요!"
            case .participant:
                return "거래가 종료되었어요!"
            }
        }
    }
    
    var badgeText: String {
        switch self {
        case .waitPay: return "모집 대기"
        case .waitPayCheck: return "입금 대기"
        case .paid: return "입금 확인중"
        case .ready: return "입금 완료"
        case .shipped: return "배송 시작"
        case .delivered: return "배송 완료"
        }
    }
    
    var badgeColor: UIColor {
        switch self {
        case .waitPay, .paid:
            return .sementicRed
        case .waitPayCheck, .delivered:
            return .gray700
        case .ready, .shipped:
            return .poti600
        }
    }
}

extension ParticipantOrderStatus {
    static func from(postStatus: MyPageJoinModel.PostStatus) -> ParticipantOrderStatus {
        switch postStatus {
            
        case .recruiting:
            return .waitPay
            
        case .recruitCompleted:
            return .waitPayCheck
            
        case .depositCompleted:
            return .ready
            
        case .shipping:
            return .shipped
            
        case .completed:
            return .delivered
        }
    }
}

extension ParticipantOrderStatus {
    var progressImage: UIImage? {
        switch self {
        case .waitPay, .waitPayCheck:
            return .imgStep0
        case .paid:
            return .imgStep1
        case .ready:
            return .imgStep2
        case .shipped:
            return .imgStep3
        case .delivered:
            return .imgStep4
        }
    }
}
