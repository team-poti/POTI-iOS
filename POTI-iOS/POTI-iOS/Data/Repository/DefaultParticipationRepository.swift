//
//  DefaultParticipationRepository.swift
//  POTI-iOS
//
//  Created by soomin on 6/11/26.
//

final class DefaultParticipationRepository: ParticipationInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func applyParticipation(entity: ParticipationEntity) async throws -> ParticipationResponseEntity {
        let requestDTO = ParticipationRequestDTO(from: entity)
        let result = try await networkService.request(
            target: ParticipationAPI.applyParticipation(request: requestDTO),
            type: ParticipationResponseDTO.self
        )
        return result.toEntity()
    }

    func fetchParticipationsDetail(participationId: Int) async throws -> JoinDetailEntity {
        let response = try await networkService.request(
            target: ParticipationAPI.fetchParticipationsDetail(participationId: participationId),
            type: ParticipationDetailDTO.self
        )
        return response.toEntity()
    }

    func patchParticipationDelivered(participationId: Int) async throws -> ParticipationDeliveredEntity {
        let response = try await networkService.request(
            target: ParticipationAPI.patchParticipationDelivered(participationId: participationId),
            type: ParticipationDeliverResponseDTO.self
        )
        return response.toEntity()
    }
}
