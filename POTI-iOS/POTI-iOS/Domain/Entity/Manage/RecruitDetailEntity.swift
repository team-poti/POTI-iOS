//
//  RecruitDetailEntity.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct RecruitDetailEntity {
    let postId: Int
    let totalCount: Int
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: PostStatus
    let statusMessage: String
    let participants: [RecruitParticipantEntity]
}

struct RecruitParticipantEntity {
    let orderId: Int
    let userId: Int
    let memberNames: [String]
    let status: ParticipantStatus
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

enum PostStatus: String {
    case recruiting = "RECRUITING"
    case closed = "CLOSED"
    case paymentDone = "PAYMENT_DONE"
    case shipping = "SHIPPING"
    case delivered = "DELIVERED"
}

/*
 RECRUITING, //모집중
 CLOSED, //모집 완료
 PAYMENT_DONE,//입금완료
 SHIPPING,//배송시작
 DELIVERED //배송완료
 */
