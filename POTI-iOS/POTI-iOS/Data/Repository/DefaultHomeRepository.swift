//
//  DefaultHomeRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

final class DefaultHomeRepository: HomeInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchHomeData() async throws -> HomeEntity {
        
        // TODO: - 서버 데이터 연결하기
        
        //        let homeDTO = try await networkService.request(
        //            target: HomeAPI.fetchHome,
        //            type: HomeDTO.self
        //        )
        //
        //        return homeDTO.toEntity()
        
        return HomeEntity(
            nickname: "수민이다",
            mainArtist: "아이브",
            myGroupItems: [
                GoodsItem(artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postTitle: "아이브 포카~", postCount: 20, tag: "인기"),
                GoodsItem(artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postTitle: "아이브 포카~", postCount: 30, tag: "인기"),
                GoodsItem(artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postTitle: "아이브 포카~", postCount: 40, tag: "인기"),
                GoodsItem(artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postTitle: "아이브 포카~", postCount: 20, tag: "인기"),
                GoodsItem(artist: "아이브", postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postTitle: "아이브 포카~", postCount: 10, tag: "인기")
            ],
            otherGroupItems: [
                GoodsItem(artist: "뉴진스", postImage: "https://i.namu.wiki/i/Y7NAscHIf-2TL6uOrBJY1D7LFK-ZJD780DROU8TSESyzqc2-U61OMwCebKFBO4FABI1uyHy0bbvSkPrwHUMnng.webp", postTitle: "뉴진스 앨범~", postCount: 20, tag: "인기"),
                GoodsItem(artist: "뉴진스", postImage: "https://i.namu.wiki/i/Y7NAscHIf-2TL6uOrBJY1D7LFK-ZJD780DROU8TSESyzqc2-U61OMwCebKFBO4FABI1uyHy0bbvSkPrwHUMnng.webp", postTitle: "뉴진스 앨범~", postCount: 25, tag: "인기"),
                GoodsItem(artist: "뉴진스", postImage: "https://i.namu.wiki/i/Y7NAscHIf-2TL6uOrBJY1D7LFK-ZJD780DROU8TSESyzqc2-U61OMwCebKFBO4FABI1uyHy0bbvSkPrwHUMnng.webp", postTitle: "뉴진스 앨범~", postCount: 32, tag: "인기"),
                GoodsItem(artist: "뉴진스", postImage: "https://i.namu.wiki/i/Y7NAscHIf-2TL6uOrBJY1D7LFK-ZJD780DROU8TSESyzqc2-U61OMwCebKFBO4FABI1uyHy0bbvSkPrwHUMnng.webp", postTitle: "뉴진스 앨범~", postCount: 12, tag: "인기"),
                GoodsItem(artist: "뉴진스", postImage: "https://i.namu.wiki/i/Y7NAscHIf-2TL6uOrBJY1D7LFK-ZJD780DROU8TSESyzqc2-U61OMwCebKFBO4FABI1uyHy0bbvSkPrwHUMnng.webp", postTitle: "뉴진스 앨범~", postCount: 92, tag: "인기")
            ],
            banners: [
                BannerItem(postId: 1, imageUrl: "https://i.namu.wiki/i/mSjjE2KvSZsCxKWsaY2MZAm8wMwIX7voGLNKBvs_t9bqOVyxy1ewEhnpkl2jDx-BjGht7GlRAJDqgd8XS_iV2g.webp"),
                BannerItem(postId: 2, imageUrl: "https://file2.nocutnews.co.kr/newsroom/image/2024/06/13/202406131531002134_0.jpg"),
                BannerItem(postId: 3, imageUrl: "https://photo.jtbc.co.kr/news/jam_photo/202508/08/1ef9ac0b-a353-4674-921b-7650a0e155ce.jpg")
            ]
        )
    }
}
