//
//  JoinDetailScreenState.swift
//  POTI-iOS
//
//  Created by Neon on 8/30/26.
//

import UIKit

enum JoinDetailContentKind: Equatable {
    case recruiting
    case recruitCompleted
    case depositCompleted
    case shipping
}

enum JoinDetailBottomAction: Equatable {
    case submitDeposit
    case completeDelivery

    var title: String {
        switch self {
        case .submitDeposit: "입금 완료했어요"
        case .completeDelivery: "배송을 받았어요"
        }
    }
}

protocol JoinDetailScreenState {
    var navigationTitle: String { get }
    var message: String? { get }
    var progressImage: UIImage? { get }
    var contentKind: JoinDetailContentKind { get }
    var bottomAction: JoinDetailBottomAction? { get }
}

private struct RecruitingJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "다른 참여자들을 기다리고 있어요"
    let progressImage: UIImage? = .imgStep0
    let contentKind: JoinDetailContentKind = .recruiting
    let bottomAction: JoinDetailBottomAction? = nil
}

private struct PaymentWaitingJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "지금 입금해주세요!"
    let progressImage: UIImage? = .imgStep1
    let contentKind: JoinDetailContentKind = .recruitCompleted
    let bottomAction: JoinDetailBottomAction? = .submitDeposit
}

private struct PaymentCheckingJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "모집자가 입금 내역을 확인하고 있어요"
    let progressImage: UIImage? = .imgStep1
    let contentKind: JoinDetailContentKind = .recruitCompleted
    let bottomAction: JoinDetailBottomAction? = nil
}

private struct PaymentCompletedJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "모집자가 배송을 준비 중이에요"
    let progressImage: UIImage? = .imgStep2
    let contentKind: JoinDetailContentKind = .depositCompleted
    let bottomAction: JoinDetailBottomAction? = nil
}

private struct ShippingJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "모집자가 배송을 시작했어요"
    let progressImage: UIImage? = .imgStep3
    let contentKind: JoinDetailContentKind = .shipping
    let bottomAction: JoinDetailBottomAction? = .completeDelivery
}

private struct DeliveredJoinState: JoinDetailScreenState {
    let navigationTitle = "종료된 분철"
    let message: String? = nil
    let progressImage: UIImage? = .imgStep4
    let contentKind: JoinDetailContentKind = .depositCompleted
    let bottomAction: JoinDetailBottomAction? = nil
}

private struct UnknownJoinState: JoinDetailScreenState {
    let navigationTitle = "진행 중인 분철"
    let message: String? = "참여 상태를 확인해주세요"
    let progressImage: UIImage? = nil
    let contentKind: JoinDetailContentKind = .recruiting
    let bottomAction: JoinDetailBottomAction? = nil
}

enum JoinDetailScreenStateFactory {
    static func make(
        postStatus: PostStatus,
        participantStatus: ParticipantOrderStatus
    ) -> any JoinDetailScreenState {
        guard participantStatus != .unknown else {
            return UnknownJoinState()
        }

        switch postStatus {
        case .recruiting:
            return RecruitingJoinState()
        case .closed:
            switch participantStatus {
            case .waitPay:
                return PaymentWaitingJoinState()
            case .waitPayCheck:
                return PaymentCheckingJoinState()
            case .paid:
                return PaymentCompletedJoinState()
            case .shipped:
                return ShippingJoinState()
            case .delivered:
                return DeliveredJoinState()
            case .unknown:
                return UnknownJoinState()
            }
        case .paymentDone:
            return PaymentCompletedJoinState()
        case .shipping:
            return ShippingJoinState()
        case .delivered:
            return DeliveredJoinState()
        }
    }
}
