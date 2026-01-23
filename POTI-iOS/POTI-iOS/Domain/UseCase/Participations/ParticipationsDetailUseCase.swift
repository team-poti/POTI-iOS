//
//  ParticipationsDetailUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ParticipationsDetailUseCase {
    func execute(participationId: Int) async throws -> JoinDetailEntity
}

final class DefaultParticipationsDetailUseCase: ParticipationsDetailUseCase {
    
    private let repository: ParticipationsInterface
    
    init(repository: ParticipationsInterface) {
        self.repository = repository
    }
    
    func execute(participationId: Int) async throws -> JoinDetailEntity {
        return try await repository.fetchParticipationsDetail(participationId: participationId)
    }
}
