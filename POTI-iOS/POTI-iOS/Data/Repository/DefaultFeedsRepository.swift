//
//  DefaultFeedsRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

final class DefaultFeedsRepository: FeedsInterface {
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity {
        let response: FeedsDTO = try await networkService.request(
            target: FeedsAPI.fetchFeeds(artistId: artistId, sort: sort, page: page),
            type: FeedsDTO.self
        )
        return response.toEntity()
    }
}
