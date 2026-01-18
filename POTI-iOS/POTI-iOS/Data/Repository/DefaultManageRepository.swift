//
//  DefaultManageRepository.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//

final class DefaultManageRepository: ManageInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchManageData(postId: Int) async throws -> ManageEntity {
        // TODO: - 서버 데이터 연결하기
        
        //        let responseDTO = try await networkService.request(
        //            target: ManageAPI.fetchManage(postId: postId),
        //            type: ManageResponseDTO.self
        //        )
        //
        //        let participants: [ParticipantEntity] =
        //            responseDTO.data.participants.map { $0.toEntity() }
        //

        
        
        // 현재는 Mock Data 사용
        let participants: [ParticipantEntity] = [
            ParticipantEntity(
                orderId: 103,
                userId: 99,
                profileImage: "https://example.com/profile1.png",
                nickname: "안유진사랑해",
                memberNames: ["리즈"],
                status: .waitPay,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "리즈", price: 3500)
                    ],
                    shippingName: "준등기",
                    shippingPrice: 1500,
                    totalPrice: 7500
                ),
                depositInfo: nil,
                shippingInfo: ShippingInfoEntity(
                    receiverName: "이수민",
                    address: "(01234) 서울특별시 솜트구...",
                    phone: "010-2345-2345",
                    trackingNumber: nil
                )
            ),
            ParticipantEntity(
                orderId: 101,
                userId: 55,
                profileImage: "https://example.com/profile2.png",
                nickname: "참여자2",
                memberNames: ["레이", "이서"],
                status: .waitPayCheck,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "레이", price: 3500),
                        MemberPerPriceEntity(name: "이서", price: 3500)
                    ],
                    shippingName: "준등기",
                    shippingPrice: 1500,
                    totalPrice: 9000
                ),
                depositInfo: DepositInfoEntity(
                    depositorName: "이포티",
                    depositTime: "2025-12-30T02:50"
                ),
                shippingInfo: ShippingInfoEntity(
                    receiverName: "이수민",
                    address: "(01234) 서울특별시 솜트구...",
                    phone: "010-2345-2345",
                    trackingNumber: nil
                )
            ),
            ParticipantEntity(
                orderId: 101,
                userId: 555,
                profileImage: "https://example.com/profile2.png",
                nickname: "참여자2",
                memberNames: ["나연", "수민","정환", "명진", "채륜", "나영", "채연"],
                status: .waitPayCheck,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "나연", price: 5500),
                        MemberPerPriceEntity(name: "수민", price: 5500),
                        MemberPerPriceEntity(name: "정환", price: 1500),
                        MemberPerPriceEntity(name: "명진", price: 500),
                        MemberPerPriceEntity(name: "채륜", price: 2000),
                        MemberPerPriceEntity(name: "나영", price: 1000000)
                    ],
                    shippingName: "준등기",
                    shippingPrice: 1500,
                    totalPrice: 2000000
                ),
                depositInfo: DepositInfoEntity(
                    depositorName: "이포티",
                    depositTime: "2025-12-30T02:50"
                ),
                shippingInfo: ShippingInfoEntity(
                    receiverName: "이수민",
                    address: "(01234) 서울특별시 솜트구...",
                    phone: "010-2345-2345",
                    trackingNumber: nil
                )
            )]
                
        
        return ManageEntity(participants: participants)
        
    }
}
