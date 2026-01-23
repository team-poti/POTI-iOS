protocol ParticipationsInterface {
    func fetchMyParticipationsHistory(status: String) async throws -> MyPageParticipationsHistoryEntity
    func fetchParticipationsDetail(participationId: Int) async throws -> JoinDetailEntity
    func patchParticipationDelivered(participationId: Int) async throws
}