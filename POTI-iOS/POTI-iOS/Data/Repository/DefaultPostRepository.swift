//
//  DefaultPostRepository.swift
//  POTI-iOS
//
//  Created by soomin on 6/6/26.
//

final class DefaultPostRepository: PostInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchHomeData() async throws -> HomeEntity {
        let homeDTO: HomeDTO = try await networkService.request(
            target: PostAPI.fetchHome,
            type: HomeDTO.self
        )
        return homeDTO.toEntity()
    }

    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity {
        let response: FeedsDTO = try await networkService.request(
            target: PostAPI.fetchFeeds(artistId: artistId, sort: sort, page: page),
            type: FeedsDTO.self
        )
        return response.toEntity()
    }

    func fetchPotListData(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity {
        let response: PotListDTO = try await networkService.request(
            target: PostAPI.fetchPotList(title: title, artistId: artistId, memberIds: memberIds, sort: sort, page: page),
            type: PotListDTO.self
        )
        return response.toEntity()
    }

    func fetchPotDetail(postId: Int) async throws -> PotDetailEntity {
        let response: PotDetailDTO = try await networkService.request(
            target: PostAPI.fetchPotDetail(postId: postId),
            type: PotDetailDTO.self
        )
        return response.toEntity()
    }

    func fetchPotOptions(postId: Int) async throws -> PotOptionsEntity {
        let response: PotOptionsDTO = try await networkService.request(
            target: PostAPI.fetchPotOptions(postId: postId),
            type: PotOptionsDTO.self
        )
        return response.toEntity()
    }
}
