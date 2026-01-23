//
//  MyPageJoinModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

struct MyPageJoinModel: Hashable {
    let participationId: Int
    let postId: Int
    let imageUrlString: String
    let artistName: String
    let title: String

    let postStatus: PostStatus
    let orderStatus: ParticipantOrderStatus
    let statusMessage: String

    let memberPayments: [MemberPaymentRow]
    let paymentInfo: PaymentInfo
    let shippingInfo: ShippingInfo

    // MARK: - Nested Types

    struct MemberPaymentRow: Hashable {
        let memberName: String
        let price: Int
    }

    struct PaymentInfo: Hashable {
        let shippingFee: Int
        let totalAmount: Int
        let depositStatus: DepositStatus
        let bank: String?
        let accountNumber: String?
        let depositDeadline: String?
    }

    struct ShippingInfo: Hashable {
        let shippingMethod: String
        let receiver: String
        let zipcode: String
        let address: String
        let phone: String
        let carrier: String?
        let trackingNumber: String?
        let shippingStatus: ShippingStatus
    }
}

extension MyPageJoinModel {
    enum PostStatus: String, Hashable {
        case recruiting = "RECRUITING"
        case recruitCompleted = "RECRUIT_COMPLETED"
        case depositCompleted = "DEPOSIT_COMPLETED"
        case shipping = "SHIPPING"
        case completed = "COMPLETED"

        var potStatusText: String {
            switch self {
            case .recruiting:
                return "모집 중"
            case .recruitCompleted:
                return "모집 완료"
            case .depositCompleted:
                return "입금 완료"
            case .shipping:
                return "배송 시작"
            case .completed:
                return "배송 완료"
            }
        }

        var potStatusColor: UIColor {
            switch self {
            case .recruiting:
                return .sementicRed
            case .recruitCompleted:
                return .poti600
            case .depositCompleted:
                return .gray700
            case .shipping:
                return .poti600
            case .completed:
                return .gray700
            }
        }
    }

    enum OrderStatus: String, Hashable {
        case waiting = "WAITING"
        case shipped = "SHIPPED"
        case delivered = "DELIVERED"
    }

    enum DepositStatus: String, Hashable {
        case waiting = "WAITING"
        case shipped = "SHIPPED"
        case completed = "COMPLETED"
        
        var text: String {
            switch self {
            case .waiting:
                return "입금 대기"
            case .shipped:
                return "입금 확인중"
            case .completed:
                return "입금 완료"
            }
        }
        
        var badgeColor: UIColor {
                switch self {
                case .waiting:
                    return .sementicRed
                case .shipped:
                    return .poti600
                case .completed:
                    return .gray700
                }
            }
    }

    enum ShippingStatus: String, Hashable {
        case preparing = "PREPARING"
        case shipped = "SHIPPED"
        case delivered = "DELIVERED"
        
        var text: String {
            switch self {
            case .preparing:
                return "배송 대기"
            case .shipped:
                return "배송 시작"
            case .delivered:
                return "배송 완료"
            }
        }
        
        var badgeColor: UIColor {
            switch self {
            case .preparing:
                return .sementicRed
            case .shipped:
                return .poti600
            case .delivered:
                return .gray700
            }
        }
    }
}

// MARK: - JoinDetailEntity → MyPageJoinModel Mapping

extension MyPageJoinModel {

    /// 서버 상세(Entity) → 화면용 Model 변환
    static func map(entity: JoinDetailEntity) -> MyPageJoinModel {
        MyPageJoinModel(
            participationId: entity.participationId, postId: entity.postId,
            imageUrlString: entity.imageUrl,
            artistName: entity.artistName,
            title: entity.title,
            postStatus: MyPageJoinModel.PostStatus.from(entity.postStatus),
            // 상세 응답에는 별도 orderStatus 필드가 없어서, 배송 상태를 대표값으로 사용
            orderStatus: entity.shippingInfo.shippingStatus,
            statusMessage: entity.statusMessage,
            memberPayments: entity.memberPayments.map { .init(memberName: $0.memberName, price: $0.price) },
            paymentInfo: PaymentInfo(
                shippingFee: entity.paymentInfo.shippingFee,
                totalAmount: entity.paymentInfo.totalAmount,
                depositStatus: DepositStatus.from(entity.paymentInfo.depositStatus),
                bank: entity.paymentInfo.bank,
                accountNumber: entity.paymentInfo.accountNumber,
                depositDeadline: entity.paymentInfo.depositDeadline
            ),
            shippingInfo: ShippingInfo(
                shippingMethod: entity.shippingInfo.shippingMethod,
                receiver: entity.shippingInfo.receiver,
                zipcode: entity.shippingInfo.zipcode,
                address: entity.shippingInfo.address,
                phone: entity.shippingInfo.phone,
                carrier: entity.shippingInfo.carrier,
                trackingNumber: entity.shippingInfo.trackingNumber,
                shippingStatus: ShippingStatus.from(entity.shippingInfo.shippingStatus)
            )
        )
    }
}

// MARK: - Status Mapping Helpers

extension MyPageJoinModel.DepositStatus {
    static func from(_ status: ParticipantOrderStatus) -> MyPageJoinModel.DepositStatus {
        // 서버 상태 → 입금 상태
        // WAIT_PAY(입금대기), WAIT_PAY_CHECK(입금확인중), PAID/READY/SHIPPED/DELIVERED(입금완료로 간주)
        switch status {
        case .waitPay:
            return .waiting
        case .waitPayCheck:
            return .shipped
        case .paid, .ready, .shipped, .delivered:
            return .completed
        }
    }
}

extension MyPageJoinModel.ShippingStatus {
    static func from(_ status: ParticipantOrderStatus) -> MyPageJoinModel.ShippingStatus {
        // 서버 상태 → 배송 상태
        // READY(배송대기), SHIPPED(배송시작), DELIVERED(배송완료)
        switch status {
        case .ready:
            return .preparing
        case .shipped:
            return .shipped
        case .delivered:
            return .delivered
        case .waitPay, .waitPayCheck, .paid:
            // 배송 단계 이전 상태들은 '배송 대기'로 표시
            return .preparing
        }
    }
}

extension MyPageJoinModel.PostStatus {
    static func from(_ status: PostStatus) -> MyPageJoinModel.PostStatus {
        switch status {
        case .recruiting:
            return .recruiting
        case .closed:
            return .recruitCompleted
        case .paymentDone:
            return .depositCompleted
        case .shipping:
            return .shipping
        case .delivered:
            return .completed
        }
    }
}
