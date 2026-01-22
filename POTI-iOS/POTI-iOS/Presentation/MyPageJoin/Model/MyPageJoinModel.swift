//
//  MyPageJoinModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

struct MyPageJoinModel: Hashable {
    let participationId: Int
    let imageUrlString: String
    let artistName: String
    let title: String

    let postStatus: PostStatus
    let orderStatus: OrderStatus
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
        let carrier: String
        let trackingNumber: String
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

extension MyPageJoinModel {
    var participantManageCellModel: ParticipantManageViewCell.Model {
        .init(
            memberNamesText: memberPayments.map { $0.memberName },
            depositorNameText: shippingInfo.receiver,
            addressText: shippingInfo.address,
            phoneText: shippingInfo.phone,
            shippingText: shippingInfo.shippingMethod,
            totalPrice: paymentInfo.totalAmount,
            depositState: ParticipantOrderStatus.from(postStatus: postStatus)
        )
    }
}
