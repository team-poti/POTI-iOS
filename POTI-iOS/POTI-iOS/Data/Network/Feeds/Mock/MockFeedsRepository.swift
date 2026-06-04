//
//  MockFeedsRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 6/4/26.
//

import Foundation

final class MockFeedsRepository: FeedsInterface {
    
    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity {
        if page > 0 {
            return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: [])
        }
        
        let totalItems = [
            GroupItem(title: "아이브앨범", artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postCount: 12, tag: "인기"),
            GroupItem(title: "아일릿포카", artist: "아일릿", artistId: 2, postImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", postCount: 7, tag: "인기"),
            GroupItem(title: "아이브시그", artist: "아이브", artistId: 1, postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", postCount: 20, tag: "인기"),
            GroupItem(title: "아일릿 인형", artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postCount: 23, tag: "")
        ]
        
        let filteredItems: [GroupItem]
        if let id = artistId, id != 0 {
            filteredItems = totalItems.filter { $0.artistId == id }
        } else {
            filteredItems = totalItems
        }
        
        switch sort {
        case .hot:
            let sorted = filteredItems.sorted { $0.postCount > $1.postCount }
            return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: sorted)
            
        case .latest:
            return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: filteredItems)
            
        case .random:
            return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: filteredItems)
        }
    }
}
