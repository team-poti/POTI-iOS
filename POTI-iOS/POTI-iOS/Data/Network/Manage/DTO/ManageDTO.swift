//
//  ManageDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

struct ManageResponseDataDTO: Decodable {
    let participants: [ParticipantManageDTO]
}

struct ParticipantManageDTO: Decodable {
    let orderId: Int
    let userId: Int
    let profileImage: String?
    let nickname: String
    let memberNames: [String]
    let status: ParticipantManageStatusDTO

    let priceInfo: PriceInfoDTO
    let depositInfo: DepositInfoDTO?
    let shippingInfo: ShippingInfoDTO?
}

enum ParticipantManageStatusDTO: String, Decodable {
    case recruiting = "RECRUITING" // 모집 대기
    case waitPay = "WAIT_PAY" // 입금 대기
    case waitPayCheck = "WAIT_PAY_CHECK" // 입금 확인중
    case paid = "PAID" // 입금 완료
    case shipped = "SHIPPED" // 배송 시작
    case delivered = "DELIVERED" // 배송 완료
    
    func toEntity() -> ParticipantStatus {
        switch self {
        case .recruiting : return .waitRecruit
        case .waitPay : return .waitPay
        case .waitPayCheck : return .waitPayCheck
        case .paid : return .paid
        case .shipped : return .startShip
        case .delivered : return .completed
        }
    }
}

struct PriceInfoDTO: Decodable {
    let memberPerPrices: [MemberPerPriceDTO]
    let shippingName: String
    let shippingPrice: Int
    let totalPrice: Int
    
    func toEntity() -> PriceInfoEntity {
        .init(
            memberPerPrices: memberPerPrices.map { $0.toEntity() },
            shippingName: shippingName,
            shippingPrice: shippingPrice,
            totalPrice: totalPrice
        )
    }
}

struct MemberPerPriceDTO: Decodable {
    let name: String
    let price: Int
    
    func toEntity() -> MemberPerPriceEntity {
        .init(name: name, price: price)
    }
}

struct DepositInfoDTO: Decodable {
    let depositorName: String
    let depositTime: String
    
    func toEntity() -> DepositInfoEntity {
        .init(depositorName: depositorName, depositTime: depositTime)
    }
}

struct ShippingInfoDTO: Decodable {
    let receiverName: String
    let address: String
    let phone: String
    let trackingNumber: String?
    
    func toEntity() -> ShippingInfoEntity {
        .init(receiverName: receiverName, address: address, phone: phone, trackingNumber: trackingNumber)
    }
}

extension ParticipantManageDTO {
    func toEntity() -> ParticipantEntity {
        return .init(
            orderId: orderId,
            userId: userId,
            profileImage: profileImage,
            nickname: nickname,
            memberNames: memberNames,
            status: status.toEntity(),
            priceInfo: priceInfo.toEntity(),
            depositInfo: depositInfo?.toEntity(),
            shippingInfo: shippingInfo?.toEntity())
    }
}
