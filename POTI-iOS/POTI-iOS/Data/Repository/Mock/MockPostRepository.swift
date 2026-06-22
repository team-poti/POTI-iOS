//
//  MockPostRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 6/8/26.
//

import Foundation

final class MockPostRepository: PostInterface {
    func fetchHomeData() async throws -> HomeEntity {
        return createMockHomeEntity(mainArtistId: 1, isFallback: false)
    }
    
    private func createMockHomeEntity(mainArtistId: Int?, isFallback: Bool) -> HomeEntity {
        let myItems = [
            GoodsEntity(artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postTitle: "아이브다", postCount: 12, tag: "인기"),
            GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿포카", postCount: 23, tag: "")
        ]
        
        return HomeEntity(
            nickname: "수민",
            mainArtist: mainArtistId == 1 ? "아이브" : nil,
            mainArtistId: mainArtistId,
            myGroupItems: myItems,
            otherGroupItems: [
                GoodsEntity(artist: "아일릿", artistId: 2, postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", postTitle: "아일릿잇츠미" , postCount: 23, tag: "")
            ],
            banners: [
                BannerEntity(postId: 101, imageUrl: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg")
            ]
        )
    }
    
    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity {
        if page > 0 {
            return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: [])
        }
        
        let totalItems = [
            GroupItem(title: "아이브앨범", artist: "아이브", artistId: 1, postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75", postCount: 12, tag: "인기")
        ]
        
        return FeedsEntity(nickname: "수민", mainArtist: "아이브", mainArtistId: 1, groupItems: totalItems)
    }
    
    func fetchPotListData(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity {
        if page > 0 {
            return PotListEntity(postTitle: title, artistId: artistId, artist: "아이브", currentPage: page, hasNext: false, pots: [])
        }
        
        let totalPotsWithMeta: [(pot: Pot, memberIds: [Int])] = [
            (
                pot: Pot(
                    potId: 1001,
                    price: 15000,
                    thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg",
                    currentCount: 3,
                    totalCount: 6,
                    status: "RECRUITING",
                    availableMembers: ["장원영", "안유진", "레이"],
                    recruiter: Recruiter(userId: 501, nickname: "유진최애", profileImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", rating: 4.9)
                ),
                memberIds: [10, 11, 12]
            ),
            (
                pot: Pot(
                    potId: 1002,
                    price: 12000,
                    thumbnailUrl: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75",
                    currentCount: 1,
                    totalCount: 4,
                    status: "RECRUITING",
                    availableMembers: ["안유진", "리즈"],
                    recruiter: Recruiter(userId: 502, nickname: "안댕댕", profileImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", rating: 4.2)
                ),
                memberIds: [11, 13]
            ),
            (
                pot: Pot(
                    potId: 1003,
                    price: 23000,
                    thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg",
                    currentCount: 5,
                    totalCount: 5,
                    status: "CLOSED",
                    availableMembers: ["장원영"],
                    recruiter: Recruiter(userId: 503, nickname: "앙티", profileImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", rating: 5.0)
                ),
                memberIds: [10]
            ),
            (
                pot: Pot(
                    potId: 1004,
                    price: 14000,
                    thumbnailUrl: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75",
                    currentCount: 2,
                    totalCount: 6,
                    status: "RECRUITING",
                    availableMembers: ["레이", "이서", "가을"],
                    recruiter: Recruiter(userId: 504, nickname: "수만두", profileImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", rating: 4.7)
                ),
                memberIds: [12, 14, 15]
            ),
            (
                pot: Pot(
                    potId: 1005,
                    price: 16500,
                    thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg",
                    currentCount: 4,
                    totalCount: 5,
                    status: "RECRUITING",
                    availableMembers: ["장원영", "리즈"],
                    recruiter: Recruiter(userId: 505, nickname: "우하하", profileImage: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", rating: 3.8)
                ),
                memberIds: [10, 13]
            ),
            (
                pot: Pot(
                    potId: 1006,
                    price: 11000,
                    thumbnailUrl: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75",
                    currentCount: 0,
                    totalCount: 6,
                    status: "RECRUITING",
                    availableMembers: ["안유진", "이서"],
                    recruiter: Recruiter(userId: 506, nickname: "안녕하시요", profileImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg", rating: 4.5)
                ),
                memberIds: [11, 14]
            )
        ]
        
        let artistFilteredPots = totalPotsWithMeta.filter { $0.pot.potId < 2000 }
        
        var filterResult = artistFilteredPots
        if let selectedIds = memberIds, !selectedIds.isEmpty {
            filterResult = artistFilteredPots.filter { item in
                item.memberIds.contains { selectedIds.contains($0) }
            }
        }
        
        var resultPots = filterResult.map { $0.pot }
        
        switch sort {
        case "RATING":
            resultPots.sort { $0.recruiter.rating > $1.recruiter.rating }
        case "DEADLINE":
            resultPots.sort {
                let leftA = $0.totalCount - $0.currentCount
                let leftB = $1.totalCount - $1.currentCount
                return leftA < leftB
            }
        default:
            break
        }
        
        return PotListEntity(
            postTitle: title,
            artistId: artistId,
            artist: "아이브",
            currentPage: page,
            hasNext: false,
            pots: resultPots
        )
    }

    func fetchPotDetail(postId: Int) async throws -> PotDetailEntity {
        throw NSError(domain: "MockPostRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "아직 구현 X"])
    }
}
