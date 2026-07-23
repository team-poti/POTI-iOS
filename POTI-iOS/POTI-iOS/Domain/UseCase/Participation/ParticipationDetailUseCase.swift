//
//  ParticipationsDetailUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ParticipationDetailUseCase {
    func execute(participationId: Int) async throws -> JoinDetailEntity
}

final class DefaultParticipationDetailUseCase: ParticipationDetailUseCase {
    
    private let repository: ParticipationInterface
    
    init(repository: ParticipationInterface) {
        self.repository = repository
    }
    
    func execute(participationId: Int) async throws -> JoinDetailEntity {
        return try await repository.fetchParticipationsDetail(participationId: participationId)
    }
}
