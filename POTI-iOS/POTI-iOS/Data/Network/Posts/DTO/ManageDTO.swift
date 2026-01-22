//
//  ManageDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

struct ManageDTO: Decodable {
    let participants: [ManageParticipantDTO]
}

struct ManageParticipantDTO: Decodable {
    let orderId: Int
    let userId: Int
    let profileImage: String?
    let nickname: String
    let memberNames: [String]
    let status: String
    let priceInfo: ManagePriceInfoDTO
    let depositInfo: DepositInfoDTO?
    let shippingInfo: ManageShippingInfoDTO?
}

struct ManagePriceInfoDTO: Decodable {
    let memberPerPrices: [ManageMemberPerPriceDTO]
    let shippingName: String
    let shippingPrice: Int
    let totalPrice: Int
}

struct ManageMemberPerPriceDTO: Decodable {
    let name: String
    let price: Int
}

struct DepositInfoDTO: Decodable {
    let depositorName: String
    let depositTime: String
}

struct ManageShippingInfoDTO: Decodable {
    let receiverName: String
    let address: String
    let phone: String
    let trackingNumber: String?
}


extension ManageDTO {
    func toEntity() -> ManageEntity {
        ManageEntity(
            participants: participants.map { $0.toEntity() }
        )
    }
}

extension ManageParticipantDTO {
    func toEntity() -> ManageParticipantEntity {
        ManageParticipantEntity(
            orderId: orderId,
            userId: userId,
            profileImage: profileImage,
            nickname: nickname,
            memberNames: memberNames,
            status: ParticipantStatus(rawValue: status) ?? .recruiting,
            priceInfo: priceInfo.toEntity(),
            depositInfo: depositInfo?.toEntity(),
            shippingInfo: shippingInfo?.toEntity()
        )
    }
}

extension ManagePriceInfoDTO {
    func toEntity() -> PriceInfoEntity {
        PriceInfoEntity(
            memberPerPrices: memberPerPrices.map { $0.toEntity() },
            shippingName: shippingName,
            shippingPrice: shippingPrice,
            totalPrice: totalPrice
        )
    }
}

extension ManageMemberPerPriceDTO {
    func toEntity() -> MemberPerPriceEntity {
        MemberPerPriceEntity(name: name, price: price)
    }
}

extension DepositInfoDTO {
    func toEntity() -> DepositInfoEntity {
        DepositInfoEntity(
            depositorName: depositorName,
            depositTime: depositTime
        )
    }
}

extension ManageShippingInfoDTO {
    func toEntity() -> ShippingInfoEntity {
        ShippingInfoEntity(
            receiverName: receiverName,
            address: address,
            phone: phone,
            trackingNumber: trackingNumber
        )
    }
}
