//
//  MockHomeRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 5/24/26.
//

import Foundation

final class MockHomeRepository: HomeInterface {
    func fetchHomeData() async throws -> HomeEntity {
        return HomeEntity(
            nickname: "수민",
            mainArtist: "아이브",
            mainArtistId: 1,
            myGroupItems: [
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브앨범", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://i.namu.wiki/i/4UpYama5GLAuolzuYIOjDlAOtPj22timMlsOK0jugcyJ4_rcaJwWqDptVGx0g2udsaAHA4vp2bLbVMiZ63EqOA.webp", postTitle: "아이브앨범", postCount: 5, tag: "")
            ],
            otherGroupItems: [
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카" , postCount: 23, tag: ""),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", postTitle: "아일릿포카", postCount: 7, tag: "인기")
            ],
            banners: [
                BannerEntity(postId: 101, imageUrl: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg"),
                BannerEntity(postId: 102, imageUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg"),
                BannerEntity(postId: 103, imageUrl: "https://sports.hankooki.com/news/photo/202406/6865580_1085568_126.jpeg"),
            ]
        )
    }
}
