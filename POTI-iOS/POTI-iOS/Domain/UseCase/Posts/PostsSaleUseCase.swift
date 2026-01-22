//
//  PostsSaleUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

protocol PostsSaleUseCase {
    func execute(postId: Int) async throws -> RecruitDetailEntity
}

final class DefaultPostsSaleUseCase: PostsSaleUseCase {
    
    private let repository: PostsInterface
    
    init(repository: PostsInterface) {
        self.repository = repository
    }
    
    func execute(postId: Int) async throws -> RecruitDetailEntity {
        return try await repository.fetchSaleDetail(postId: postId)
    }
}
