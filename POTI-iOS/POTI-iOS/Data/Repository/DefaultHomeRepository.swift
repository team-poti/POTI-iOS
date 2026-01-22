//
//  DefaultHomeRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

final class DefaultHomeRepository: HomeInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchHomeData() async throws -> HomeEntity {
        let homeDTO: HomeDTO = try await networkService.request(
            target: HomeAPI.fetchHome,
            type: HomeDTO.self
        )
        return homeDTO.toEntity()
    }
}
