//
//  MyPageParticipationsHistoryUseCase.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

protocol MyPageParticipationsHistoryUseCase {
    func execute(status: String) async throws -> MyPageParticipationsHistoryEntity
}

final class DefaultMyPageParticipationsHistoryUseCase: MyPageParticipationsHistoryUseCase {
    private let repository: ParticipationsInterface
    
    init(repository: ParticipationsInterface) {
        self.repository = repository
    }
    
    func execute(status: String) async throws -> MyPageParticipationsHistoryEntity {
        try await repository.fetchMyParticipationsHistory(status: status)
    }
}
