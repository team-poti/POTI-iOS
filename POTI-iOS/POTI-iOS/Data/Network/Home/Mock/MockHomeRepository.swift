//
//  MockHomeRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 5/24/26.
//

import Foundation

final class MockHomeRepository: HomeInterface {
    func fetchHomeData() async throws -> HomeEntity {
        // 최애 아티스트, 아티스트의 분철글 모두 존재할 때
        return createMockEntity(mainArtistId: 1, isFallback: false)
        
        // 최애 아티스트는 존재하지만 분철글이 존재하지 않을 때
        // return createMockEntity(mainArtistId: 1, isFallback: true)
        
        // 최애 아티스트가 없을 때
        // return createMockEntity(mainArtistId: nil, isFallback: true)
    }
    
    private func createMockEntity(mainArtistId: Int?, isFallback: Bool) -> HomeEntity {
        let myItems: [GoodsEntity]
        
        if mainArtistId == nil || isFallback {
            myItems = [
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: ""),
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: ""),
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: "")
            ]
        } else {
            myItems = [
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: ""),
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: ""),
                GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: "")
            ]
        }
        
        return HomeEntity(
            nickname: "수민",
            mainArtist: mainArtistId == 1 ? "아이브" : nil,
            mainArtistId: mainArtistId,
            myGroupItems: myItems,
            otherGroupItems: [
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿잇츠미" , postCount: 23, tag: ""),
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", postTitle: "아일릿이지롱", postCount: 7, tag: "인기")
            ],
            banners: [
                BannerEntity(postId: 101, imageUrl: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg"),
                BannerEntity(postId: 102, imageUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg"),
                BannerEntity(postId: 101, imageUrl: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg")
            ]
        )
    }
}
