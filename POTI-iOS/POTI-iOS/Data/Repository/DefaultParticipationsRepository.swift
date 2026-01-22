//
//  DefaultParticipationsRepository.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

final class DefaultParticipationsRepository: ParticipationsInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMyParticipationsHistory(status: String) async throws -> MyPageParticipationsHistoryEntity {
        let result = try await networkService.request(target: ParticipationsAPI.fetchMyParticipationsHistory(status: status), type: MyParticipationsResponseDTO.self)
        return result.toEntity()
    }
}
