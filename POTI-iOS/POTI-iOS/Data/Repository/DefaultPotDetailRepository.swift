//
//  DefaultPotDetailRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

final class DefaultPotDetailRepository: PotDetailInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPotDetail() async throws -> PotDetailEntity {
        
        // TODO: - 서버 데이터 연결하기
        
        //        let potDetailDTO = try await networkService.request(
        //            target: PotDetailAPI.fetchPotDetail,
        //            type: PotDetailDTO.self
        //        )
        //        return PotDetailDTO.toEntity()
        
        return PotDetailEntity(
            postId: 1,
            isMyPost: false,
            status: "RECRUITING",
            artist: "아이브",
            title: "아이브 미니 2집 분철합니다!",
            price: 15000,
            uploadTime: "2026-01-22 등록",
            deadline: "2026-01-25",
            images: [
                "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/sd/2025/08/25/132250320.1.jpg",
                "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2024/05/23/8984e9ca-7b94-43db-ad29-8e3d9045ec1b.jpg",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-PqPTP894d7O40KW5v12bzcJ3Rvhjbo3I2A&s"
            ],
            content: "숨 참고 러브다이부~",
            shippingOptions: [
                ShippingOption(shippingId: 1, name: "반값택배", price: 1800),
                ShippingOption(shippingId: 2, name: "일반택배", price: 3500)
            ],
            uploader: Uploader(
                userId: 100,
                nickname: "포티타임",
                profileImage: "https://thumbnail.coupangcdn.com/thumbnails/remote/492x492ex/image/vendor_inventory/ae84/747a5be247b49cd2dfd117e88ec623205bb5552ae9ea66545e0b112a171c.jpg",
                rating: 4.8,
                reviewCount: 24
            ),
            currentCount: 2,
            totalCount: 6,
            participants: [
                ParticipantInfo(userId: 1, nickname: "수민", profileImage: "https://i.pinimg.com/736x/09/fb/34/09fb346daa863cd3389f237009ab2940.jpg", rating: 5.0, selectedMembers: ["이서", "레이"]),
                ParticipantInfo(userId: 2, nickname: "포숭이", profileImage: "https://i.pinimg.com/564x/9c/78/f8/9c78f8a5ed77c5bb14443360fc3f3521.jpg", rating: 4.5, selectedMembers: ["리즈"])
            ]
        )
    }
}
