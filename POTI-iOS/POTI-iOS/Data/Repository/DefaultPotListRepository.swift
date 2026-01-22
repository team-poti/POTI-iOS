//
//  DefaultPotListRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

final class DefaultPotListRepository: PotListInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchPotListData(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity {
        let response: PotListDTO = try await networkService.request(
            target: PotListAPI.fetchPotList(title: title, artistId: artistId, memberIds: memberIds, sort: sort, page: page),
            type: PotListDTO.self
        )
        return response.toEntity()
    }
}

