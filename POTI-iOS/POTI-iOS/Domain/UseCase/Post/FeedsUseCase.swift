//
//  FeedsUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol FeedsUseCase {
    func execute(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity
}

final class DefaultFeedsUseCase: FeedsUseCase {
    private let repository: PostInterface
    
    init(repository: PostInterface) {
        self.repository = repository
    }
    
    func execute(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity {
        return try await repository.fetchFeedsData(
            artistId: artistId,
            sort: sort,
            page: page
        )
    }
}

