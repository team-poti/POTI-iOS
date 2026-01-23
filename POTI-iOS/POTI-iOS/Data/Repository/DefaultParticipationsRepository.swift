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

    func fetchMyParticipationsHistory(status: String) async throws -> MyPageParticipationsHistoryEntity {
        let result = try await networkService.request(target: ParticipationsAPI.fetchMyParticipationsHistory(status: status), type: MyParticipationsResponseDTO.self)
        return result.toEntity()
    }
}