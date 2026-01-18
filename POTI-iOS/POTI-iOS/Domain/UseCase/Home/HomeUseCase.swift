//
//  HomeUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol HomeUseCase {
    func execute() async throws -> HomeEntity
}

final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeInterface
    
    init(repository: HomeInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> HomeEntity {
        return try await repository.fetchHomeData()
    }
}
