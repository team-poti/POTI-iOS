//
//  DefaultPostsRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

final class DefaultPostsRepository: PostsInterface {
    func fetchManagerData(postId: Int) async throws -> ManageEntity {
        //        let responseDTO = try await networkService.request(
        //            target: PostsAPI.fetchManagerData(postId: postId)
        //            return dto.toEntity()
        //          }
        //      }
        //
        // 현재는 Mock Data 사용
        let participants: [ParticipantEntity] = [
            ParticipantEntity(
                orderId: 101,
                userId: 99,
                profileImage: "https://example.com/image1.jpg",
                nickname: "gk",
                memberNames: ["리즈"],
                status: .shipped,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "리즈", price: 6000)
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
                profileImage: nil,
                nickname: "참여자2",
                memberNames: ["레이", "이서"],
                status: .paid,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "레이", price: 3750),
                        MemberPerPriceEntity(name: "이서", price: 3750)
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
                    address: "(01234) 서울특별시 서대문구 연희동",
                    phone: "010-2345-2345",
                    trackingNumber: nil
                )
            ),
            ParticipantEntity(
                orderId: 102,
                userId: 555,
                profileImage: nil,
                nickname: "참여자3",
                memberNames: ["나연", "수민", "정환", "명진", "채륜", "나영", "채연"],
                status: .waitPayCheck,
                priceInfo: PriceInfoEntity(
                    memberPerPrices: [
                        MemberPerPriceEntity(name: "나연", price: 300000),
                        MemberPerPriceEntity(name: "수민", price: 300000),
                        MemberPerPriceEntity(name: "정환", price: 200000),
                        MemberPerPriceEntity(name: "명진", price: 200000),
                        MemberPerPriceEntity(name: "채륜", price: 200000),
                        MemberPerPriceEntity(name: "나영", price: 350000),
                        MemberPerPriceEntity(name: "채연", price: 250000)
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
            )
        ]
        
        return ManageEntity(
            participants: participants
        )
    }
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchOrderOptions(postId: Int) async throws -> PotOptionsEntity {
        
        // TODO: - 서버 데이터로 변경하기
        
        let members = mockMembers.map {
            MemberEntity(id: $0.memberOptionId, name: $0.memberName, price: $0.memberOptionPrice)
        }
        
        let shippings = mockShippings.map {
            ShippingEntity(id: $0.deliveryOptionId, name: $0.deliveryName, price: $0.deliveryOptionPrice)
        }
        
        return PotOptionsEntity(members: members, shippings: shippings)
    }
    
    
    func fetchSaleDetail(postId: Int) async throws -> RecruitDetailEntity {
        // TODO: - 서버 데이터 연결하기
        let responseDTO = try await networkService.request(
            target: PostsAPI.fetchSaleDetail(postId: postId), type: RecruitDetailDTO.self
        )
        return responseDTO.toEntity()
        //        let responseDTO = try await networkService.request(
        //            target: PostsAPI.fetchManagerData(postId: postId)
        //            return dto.toEntity()
        //          }
        //      }
        //
        
    }
}
