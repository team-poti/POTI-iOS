//
//  DefaultParticipationsRepository.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

final class DefaultParticipationsRepository: ParticipationsInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchParticipationsDetail(participationId: Int) async throws -> JoinDetailEntity {
        let response = try await networkService.request(
            target: ParticipationsAPI.fetchParticipation(participationId: participationId),
            type: ParticipationDetailDTO.self
        )
        return response.toEntity()
    }
}
