//
//  RecruitDetailDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct RecruitDetailDTO: Decodable {
    let postId: Int
    let orderNumber: String
    let totalCount: Int
    let imageUrl: String
    let artistName: String
    let title: String
    let postStatus: String
    let statusMessage: String
    let participant: [RecruitParticipantDTO]
}

struct RecruitParticipantDTO: Decodable {
    let orderId: Int
    let userId: Int
    let memberNames: [String]
    let status: String
    let priceInfo: PriceInfoDTO
    let shippingInfo: ShippingInfoDTO
}

struct PriceInfoDTO: Decodable {
    let shippingName: String
    let totalPrice: Int
}

struct ShippingInfoDTO: Decodable {
    let receiverName: String
    let address: String
    let phone: String
}

extension RecruitDetailDTO {
    func toEntity() -> RecruitDetailEntity {
        return RecruitDetailEntity(
            postId: postId,
            orderNumber: orderNumber,
            totalCount: totalCount,
            imageUrl: imageUrl,
            artistName: artistName,
            title: title,
            postStatus: PostStatus(rawValue: postStatus) ?? .recruiting,
            statusMessage: statusMessage,
            participant: participant.map { $0.toEntity() }
        )
    }
}

extension RecruitParticipantDTO {
    func toEntity() -> RecruitParticipantEntity {
        return RecruitParticipantEntity(
            orderId: orderId,
            userId: userId,
            memberNames: memberNames,
            status: ParticipantOrderStatus(rawValue: status) ?? .waitPay,
            priceInfo: priceInfo.toEntity(),
            shippingInfo: shippingInfo.toEntity()
        )
    }
}

extension PriceInfoDTO {
    func toEntity() -> RecruitPriceInfoEntity {
        .init(
            shippingName: shippingName,
            totalPrice: totalPrice
        )
    }
}

extension ShippingInfoDTO {
    func toEntity() -> RecruitShippingInfoEntity {
        .init(
            receiverName: receiverName,
            address: address,
            phone: phone
        )
    }
}
