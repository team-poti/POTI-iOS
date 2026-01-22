//
//  RecruitDetailEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import UIKit

struct RecruitDetailEntity {
    let postId: Int
    let orderNumber: String
    let totalCount: Int
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: PostStatus
    let statusMessage: String
    let participant: [RecruitParticipantEntity]
}

struct RecruitParticipantEntity {
    let orderId: Int
    let userId: Int
    let memberNames: [String]
    let status: ParticipantOrderStatus
    let priceInfo: RecruitPriceInfoEntity
    let shippingInfo: RecruitShippingInfoEntity
}

struct RecruitPriceInfoEntity {
    let shippingName: String
    let totalPrice: Int
}

struct RecruitShippingInfoEntity {
    let receiverName: String
    let address: String
    let phone: String
}

/*
 RECRUITING, //모집중
 CLOSED, //모집 완료
 PAYMENT_DONE,//입금완료
 SHIPPING,//배송시작
 DELIVERED //배송완료
 */

enum PostStatus: String {
    case recruiting = "RECRUITING"
    case closed = "CLOSED"
    case paymentDone = "PAYMENT_DONE"
    case shipping = "SHIPPING"
    case delivered = "DELIVERED"

    func statusText(role: UserRole) -> String {
        switch self {
        case .recruiting: //모집중
            return role == .host
            ? "참여자들을 기다리고 있어요"
            : "다른 참여자들을 기다리고 있어요"

        case .closed: // 모집완료
            return role == .host
            ? "입금을 기다리는 중이에요. 입금 확인을 기다리는 참여자가 있어요"
            : "지금 입금해주세요! 모집자가 입금 내역을 확인하고 있어요"

        case .paymentDone: //입금완료
            return role == .host
            ? "배송을 기다리는 참여자가 있어요"
            : "모집자가 배송을 준비 중이에요"

        case .shipping: //배송시작
            return role == .host
            ? "배송을 시작했어요"
            : "모집자가 배송을 시작했어요"

        case .delivered: //배송완료
            return "거래가 종료되었어요!"
        }
    }

    var badgeText: String {
        switch self {
        case .recruiting: return "모집 중"
        case .closed: return "입금 대기"
        case .paymentDone: return "입금 완료"
        case .shipping: return "배송 중"
        case .delivered: return "배송 완료"
        }
    }

    var badgeColor: UIColor {
        switch self {
        case .recruiting, .closed:
            return .sementicRed
        case .paymentDone, .shipping:
            return .poti600
        case .delivered:
            return .gray700
        }
    }

    var progressImage: UIImage? {
        switch self {
        case .recruiting: return .imgStep0
        case .closed: return .imgStep1
        case .paymentDone: return .imgStep2
        case .shipping: return .imgStep3
        case .delivered: return .imgStep4
        }
    }
}
