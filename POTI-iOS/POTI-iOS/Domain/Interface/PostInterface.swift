//
//  PostInterface.swift
//  POTI-iOS
//
//  Created by soomin on 6/6/26.
//

protocol PostInterface {
    func fetchHomeData() async throws -> HomeEntity
    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity
    func fetchPotListData(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity
    func fetchPotDetail(postId: Int) async throws -> PotDetailEntity
    func fetchPotOptions(postId: Int) async throws -> PotOptionsEntity
    func deletePost(postId: Int) async throws
}
