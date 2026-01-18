//
//  MyPageJoinModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import Foundation
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

// MARK: - Status Enums (네이밍 충돌 방지용: MyPageJoinModel 내부 enum)

extension MyPageJoinModel {
    enum PostStatus: String, Hashable {
        case recruiting = "RECRUITING"
        case recruitCompleted = "RECRUIT_COMPLETED"
        case depositCompleted = "DEPOSIT_COMPLETED"
        case shipping = "SHIPPING"
        case completed = "COMPLETED"
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
        
        var badgeColor: UIColor {
                switch self {
                case .waiting:
                    return .sementicRed
                case .completed:
                    return .gray700
                case .shipped:
                    return .poti600
                }
            }
    }

    enum ShippingStatus: String, Hashable {
        case preparing = "PREPARING"
        case shipped = "SHIPPED"
        case delivered = "DELIVERED"
    }
}
