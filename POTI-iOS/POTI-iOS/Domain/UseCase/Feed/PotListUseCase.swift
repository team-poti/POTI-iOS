//
//  PotListUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol PotListUseCase {
    func execute() async throws -> PotListEntity
}

final class DefaultPotListUseCase: PotListUseCase {
    private let repository: PotListInterface

    init(repository: PotListInterface) {
        self.repository = repository
    }

    func execute() async throws -> PotListEntity {
        return try await repository.fetchPotListData()
    }
}
