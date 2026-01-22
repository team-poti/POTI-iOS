//
//  DefaultGoodsListRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

final class DefaultGoodsListRepository: GoodsListInterface {
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchGoodsListData(artistId: Int, sort: String, page: Int) async throws -> GoodsListEntity {
        let response: GoodsListDTO = try await networkService.request(
            target: FeedsAPI.fetchGoodsList(artistId: artistId, sort: sort, page: page),
            type: GoodsListDTO.self
        )
        return response.toEntity()
    }
}
