//
//  ParticipationDeliveredUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 1/23/26.
//

protocol ParticipationDeliveredUseCase {
    func execute(participationId: Int) async throws -> ParticipationDeliveredEntity
}

final class DefaultParticipationDeliveredUseCase: ParticipationDeliveredUseCase {
    
    private let repository: ParticipationInterface
    
    init(repository: ParticipationInterface) {
        self.repository = repository
    }
    
    func execute(participationId: Int) async throws -> ParticipationDeliveredEntity {
        try await repository.patchParticipationDelivered(participationId: participationId)
    }
}
