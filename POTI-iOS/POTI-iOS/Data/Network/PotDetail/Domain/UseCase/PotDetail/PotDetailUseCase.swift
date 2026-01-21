//
//  PotDetailUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

protocol PotDetailUseCase {
    func execute() async throws -> PotDetailEntity
}

final class DefaultPotDetailUseCase: PotDetailUseCase {
    
    private let repository: PotDetailInterface
    
    init(repository: PotDetailInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> PotDetailEntity {
        return try await repository.fetchPotDetail()
    }
}

