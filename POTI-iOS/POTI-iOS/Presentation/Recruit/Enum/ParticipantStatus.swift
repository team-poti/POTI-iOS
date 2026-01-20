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

    func statusText(role: UserRole) -> String {
        switch self {
        case .waitRecruit:
            switch role {
            case .host:
                return "참여자들을 기다리고 있어요"
            case .participant:
                return "다른 참여자들을 기다리고 있어요"
            }
            
        case .waitPay:
            switch role {
            case .host:
                return "입금을 기다리는 중이에요. 입금 확인을 기다리는 참여자가 있어요"
            case .participant:
                return "지금 입금해주세요! 모집자가 입금 내역을 확인하고 있어요"
            }
            
        case .waitPayCheck:
            switch role {
            case .host:
                return "입금 확인을 기다리는 참여자가 있어요"
            case .participant:
                return "모집자가 입금 내역을 확인하고 있어요"
            }
            
        case .paid:
            switch role {
            case .host:
                return "배송을 기다리는 참여자가 있어요"
            case .participant:
                return "모집자가 배송을 준비 중이에요"
            }
            
        case .startShip:
            switch role {
            case .host:
                return "배송을 시작했어요"
            case .participant:
                return "모집자가 배송을 시작했어요"
            }
        case .completed:
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
        case .waitRecruit: return "모집 대기"
        case .waitPay: return "입금 대기"
        case .waitPayCheck: return "입금 확인중"
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

extension ParticipantStatus {
    static func from(postStatus: MyPageJoinModel.PostStatus) -> ParticipantStatus {
        switch postStatus {

        case .recruiting:
            return .waitRecruit

        case .recruitCompleted:
            return .waitPay

        case .depositCompleted:
            return .paid

        case .shipping:
            return .startShip

        case .completed:
            return .completed
        }
    }
}

extension ParticipantStatus {
    var progressImage: UIImage? {
        switch self {
        case .waitRecruit, .waitPay:
            return UIImage(named: "img_step0")
        case .waitPayCheck:
            return UIImage(named: "img_step1")
        case .paid:
            return UIImage(named: "img_step2")
        case .startShip:
            return UIImage(named: "img_step3")
        case .completed:
            return UIImage(named: "img_step4")
        }
    }
}
