//
//  FetchPotOptionsUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol PotOptionsUseCase {
    func execute(postId: Int) async throws -> PotOptionsEntity
}

final class DefaultPotOptionsUseCase: PotOptionsUseCase {
    private let repository: PostsInterface
    
    init(repository: PostsInterface) {
        self.repository = repository
    }
    
    func execute(postId: Int) async throws -> PotOptionsEntity {
        return try await repository.fetchOrderOptions(postId: postId)
    }
}

