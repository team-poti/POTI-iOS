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
                status: "CLOSED",
                artist: "아이브",
                title: "러브다이부",
                price: 10000,
                uploadTime: "4시간 전",
                deadline: "2026-01-25",
                images: ["https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/sd/2025/08/25/132250320.1.jpg", "https://cdn.nc.press/news/photo/202507/570556_728148_2749.jpg", "https://cf.asiaartistawards.com/news/21/2025/09/2025090910370348045_1.jpg","https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/sd/2025/08/25/132250320.1.jpg", "https://cdn.nc.press/news/photo/202507/570556_728148_2749.jpg"],
                content: "내용입니다!!!!!!!!!!",
                shippingOptions: [ShippingOption(shippingId: 1, name: "반값택배", price: 1500), ShippingOption(shippingId: 2, name: "GS반택", price: 2000)],
                uploader: Uploader(userId: 1, nickname: "포티에용", profileImage: "https://image.production.fruitsfamily.com/public/product/resized%40width1125/uaM2ycb_ZO-5F0998EF-D128-4C3D-B556-C623905A2BC7.jpg", rating: 5.0, reviewCount: 10),
                currentCount: 0,
                totalCount: 5,
                participants: [/*ParticipantInfo(userId: 1, nickname: "수민이다", profileImage: "https://contents.kyobobook.co.kr/sih/fit-in/375x0/gift/pdt/1130/hot1719368921728.jpg", rating: 4.5, selectedMembers: ["원영", "유진"]),ParticipantInfo(userId: 1, nickname: "나연이다", profileImage: "https://d2gfz7wkiigkmv.cloudfront.net/pickin/2/1/2/v30FzkJ9T1CZxzokK1Q_4Q", rating: 4.9, selectedMembers: ["이서"]), */]
            )
    }
}
