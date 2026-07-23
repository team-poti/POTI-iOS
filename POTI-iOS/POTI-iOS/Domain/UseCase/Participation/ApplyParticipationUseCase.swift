//
//  ApplyParticipationUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 6/11/26.
//

protocol ApplyParticipationUseCase {
    func execute(info: ParticipationEntity) async throws -> ParticipationResponseEntity
}

final class DefaultApplyParticipationUseCase: ApplyParticipationUseCase {
    private let repository: ParticipationInterface

    init(repository: ParticipationInterface) {
        self.repository = repository
    }

    func execute(info: ParticipationEntity) async throws -> ParticipationResponseEntity {
        return try await repository.applyParticipation(entity: info)
    }
}
