//
//  FetchPotOptionsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

protocol FetchPotOptionsUseCase {
    func execute(postId: Int) async throws -> PotOptionsEntity
}

final class DefaultFetchPotOptionsUseCase: FetchPotOptionsUseCase {
    private let repository: PostInterface
    
    init(repository: PostInterface) {
        self.repository = repository
    }
    
    func execute(postId: Int) async throws -> PotOptionsEntity {
        return try await repository.fetchPotOptions(postId: postId)
    }
}

