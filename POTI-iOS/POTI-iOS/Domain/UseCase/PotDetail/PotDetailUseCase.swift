//
//  PotDetailUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

protocol PotDetailUseCase {
    func execute(postId: Int) async throws -> PotDetailEntity
}

final class DefaultPotDetailUseCase: PotDetailUseCase {
    
    private let repository: PostInterface
    
    init(repository: PostInterface) {
        self.repository = repository
    }
    
    func execute(postId: Int) async throws -> PotDetailEntity {
        return try await repository.fetchPotDetail(postId: postId)
    }
}

