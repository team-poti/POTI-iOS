//
//  RegisterPostUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

protocol RegisterPostUseCase {
    func execute(_ entity: RegisterPostEntity) async throws -> RegisterPostResultEntity
}

final class DefaultRegisterPostUseCase: RegisterPostUseCase {
    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(_ entity: RegisterPostEntity) async throws -> RegisterPostResultEntity {
        try await repository.registerPost(entity)
    }
}
