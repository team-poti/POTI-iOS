//
//  DefaultGoodsListRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

final class DefaultGoodsListRepository: GoodsListInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchGoodsListData() async throws -> GoodsListEntity {
        
        // TODO: - 서버 데이터 연결하기
        
//        let goodsListDTO = try await networkService.request(
//            target: GoodsListAPI.fetchGoodsList,
//            type: GoodsListDTO.self
//        )
//        return goodsListDTO.toEntity()
        
        return GoodsListEntity(nickname: "앙티에용", mainArtist: "아이브", groupItems: [
            GroupItem(title: "아이브 포카~", artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 20, tag: "인기"),
            GroupItem(title: "아이브 포카~", artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 30, tag: "인기"),
            GroupItem(title: "아이브 포카~", artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 10, tag: "인기"),
            GroupItem(title: "아이브 포카~", artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 50, tag: "인기"),
            GroupItem(title: "아이브 포카~", artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 100, tag: "인기")
        ])
    }
}
