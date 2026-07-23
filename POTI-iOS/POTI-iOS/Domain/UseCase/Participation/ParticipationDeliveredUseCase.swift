//
//  ParticipationDeliveredUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ParticipationDeliveredUseCase {
    func execute(participationId: Int) async throws
}

final class DefaultParticipationDeliveredUseCase: ParticipationDeliveredUseCase {
    
    private let repository: ParticipationInterface
    
    init(repository: ParticipationInterface) {
        self.repository = repository
    }
    
    func execute(participationId: Int) async throws {
        try await repository.patchParticipationDelivered(participationId: participationId)
    }
}
