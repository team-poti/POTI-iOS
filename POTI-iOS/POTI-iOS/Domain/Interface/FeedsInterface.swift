//
//  FeedsInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol FeedsInterface {
    func fetchFeedsData(artistId: Int?, sort: FeedsSortOption, page: Int) async throws -> FeedsEntity
}
