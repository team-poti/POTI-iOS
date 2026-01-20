//
//  PotStatus.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import UIKit


enum PotStatus {
    case recruiting
    case recruitCompleted
    case depositCompleted
    case shippingStarted
    case shippingCompleted
    
    func statusText(role: UserRole) -> String {
        switch self {
        case .recruiting:
            switch role {
            case .host:
                return "참여자들을 기다리고 있어요"
            case .participant:
                return "다른 참여자들을 기다리고 있어요"
            }
            
        case .recruitCompleted:
            switch role {
            case .host:
                return "입금을 기다리는 중이에요. 입금 확인을 기다리는 참여자가 있어요"
            case .participant:
                return "지금 입금해주세요! 모집자가 입금 내역을 확인하고 있어요"
            }
            
        case .depositCompleted:
            switch role {
            case .host:
                return "배송을 기다리는 참여자가 있어요"
            case .participant:
                return "모집자가 배송을 준비 중이에요"
            }
            
        case .shippingStarted:
            switch role {
            case .host:
                return "배송을 시작했어요"
            case .participant:
                return "모집자가 배송을 시작했어요"
            }
            
        case .shippingCompleted:
            switch role {
            case .host:
                return "거래가 종료되었어요!"
            case .participant:
                return "거래가 종료되었어요!"
            }
        }
    }

    var potStatusText: String {
        switch self {
        case .recruiting:
            return "모집 중"
        case .recruitCompleted:
            return "모집 완료"
        case .depositCompleted:
            return "입금 완료"
        case .shippingStarted:
            return "배송 시작"
        case .shippingCompleted:
            return "배송 완료"
        }
    }
}

extension PotStatus {
    var progressImage: UIImage? {
        switch self {
        case .recruiting:
            return UIImage(named: "img_step0")
        case .recruitCompleted:
            return UIImage(named: "img_step1")
        case .depositCompleted:
            return UIImage(named: "img_step2")
        case .shippingStarted:
            return UIImage(named: "img_step3")
        case .shippingCompleted:
            return UIImage(named: "img_step4")
        }
    }
}

extension PotStatus {
    static func from(postStatus: MyPageJoinModel.PostStatus) -> PotStatus {
        switch postStatus {
        case .recruiting:
            return .recruiting
        case .recruitCompleted:
            return .recruitCompleted
        case .depositCompleted:
            return .depositCompleted
        case .shipping:
            return .shippingStarted
        case .completed:
            return .shippingCompleted
        }
    }
}

extension ParticipantStatus {
    static func from(participantStatus: MyPageJoinModel.PostStatus) -> ParticipantStatus {
        switch participantStatus {
            
        case .recruiting:
            return .waitRecruit
        case .recruitCompleted:
            return .waitPayCheck
        case .depositCompleted:
            return .paid
        case .shipping:
            return .startShip
        case .completed:
            return .completed
        }
    }
}
