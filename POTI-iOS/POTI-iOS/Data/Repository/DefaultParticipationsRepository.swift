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
    
    func patchParticipationDelivered(participationId: Int) async throws {
        let response = try await networkService.request(
            target: ParticipationsAPI.patchParticipationDelivered(participationId: participationId), type: ParticipationDeliverResponseDTO.self
        )
    }

}

//func postParticipationDelivered(participationId: Int) async throws -> ParticipationDeliveredEntity {
//    let response = try await networkService.request(
//        target: ParticipationsAPI.patchParticipationDelivered(participationId: participationId), type: ParticipationDeliverResponseDTO.self
//    )
//    return response.toEntity()
//}
