//
//  ParticipationsInterface.swift
//  POTI-iOS
//
//  Created by soomin on 6/11/26.
//

protocol ParticipationInterface {
    func applyParticipation(entity: ParticipationEntity) async throws -> ParticipationResponseEntity
    func fetchParticipationsDetail(participationId: Int) async throws -> JoinDetailEntity
    func patchParticipationDelivered(participationId: Int) async throws
}
