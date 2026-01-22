//
//  RegisterPostUseCase.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

protocol RegisterPostsUseCase {
    func execute(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity
}

final class DefaultRegisterPostsUseCase: RegisterPostsUseCase {

    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity {
        try await repository.registerPosts(entity)
    }
}
