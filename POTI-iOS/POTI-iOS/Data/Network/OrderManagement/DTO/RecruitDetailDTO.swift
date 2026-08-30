//
//  RecruitDetailDTO.swift
//  POTI-iOS
//
//  Created by Neon on 1/22/26.
//

struct RecruitDetailDTO: Decodable {
    let postId: Int
    let orderNumber: String?
    let totalCount: Int?
    let imageUrl: String?
    let artistName: String?
    let title: String?
    let postStatus: String?
    let statusMessage: String?
    let participant: [RecruitParticipantDTO]?
}

struct RecruitParticipantDTO: Decodable {
    let orderId: Int
    let userId: Int
    let memberNames: [String]?
    let status: String?
    let priceInfo: PriceInfoDTO?
    let shippingInfo: ShippingInfoDTO?
}

struct PriceInfoDTO: Decodable {
    let shippingName: String?
    let totalPrice: Int?
}

struct ShippingInfoDTO: Decodable {
    let receiverName: String?
    let address: String?
    let phone: String?
}

extension RecruitDetailDTO {
    func toEntity() -> RecruitDetailEntity {
        let participants = participant ?? []
        return RecruitDetailEntity(
            postId: postId,
            orderNumber: orderNumber ?? "",
            totalCount: totalCount ?? participants.count,
            imageUrl: imageUrl ?? "",
            artistName: artistName ?? "",
            title: title ?? "",
            postStatus: PostStatus(rawValue: postStatus ?? "") ?? .recruiting,
            statusMessage: statusMessage ?? "",
            participant: participants.map { $0.toEntity() }
        )
    }
}

extension RecruitParticipantDTO {
    func toEntity() -> RecruitParticipantEntity {
        return RecruitParticipantEntity(
            orderId: orderId,
            userId: userId,
            memberNames: memberNames ?? [],
            status: ParticipantStatus(rawValue: status ?? "") ?? .waitPay,
            priceInfo: priceInfo?.toEntity() ?? .empty,
            shippingInfo: shippingInfo?.toEntity() ?? .empty
        )
    }
}

extension PriceInfoDTO {
    func toEntity() -> RecruitPriceInfoEntity {
        .init(
            shippingName: shippingName ?? "",
            totalPrice: totalPrice ?? 0
        )
    }
}

extension ShippingInfoDTO {
    func toEntity() -> RecruitShippingInfoEntity {
        .init(
            receiverName: receiverName ?? "",
            address: address ?? "",
            phone: phone ?? ""
        )
    }
}

private extension RecruitPriceInfoEntity {
    static let empty = RecruitPriceInfoEntity(
        shippingName: "",
        totalPrice: 0
    )
}

private extension RecruitShippingInfoEntity {
    static let empty = RecruitShippingInfoEntity(
        receiverName: "",
        address: "",
        phone: ""
    )
}
