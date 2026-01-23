//
//  ParticipationsDeliveredUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ParticipationsDeliveredUseCase {
    func execute(participationId: Int) async throws
}

final class DefaultParticipationsDeliveredUseCase: ParticipationsDeliveredUseCase {
    
    private let repository: ParticipationsInterface
    
    init(repository: ParticipationsInterface) {
        self.repository = repository
    }
    
    func execute(participationId: Int) async throws {
        try await repository.patchParticipationDelivered(participationId: participationId)
    }
}
