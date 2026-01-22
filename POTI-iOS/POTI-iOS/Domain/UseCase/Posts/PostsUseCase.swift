//
//  PostsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//

protocol PostsParticipantsUseCase {
    func execute(postId: Int) async throws -> ManageEntity
}

final class DefaultManageUseCase: PostsParticipantsUseCase {
    
    private let repository: PostsInterface
    
    init(repository: PostsInterface) {
        self.repository = repository
    }
    
    func execute(postId: Int) async throws -> ManageEntity {
        return try await repository.fetchManagerData(postId: postId)
    }
    
    func confirmDeposit(purchaseId: Int) async throws {
        //try await repository.confirmDepositData(purchaseId: purchaseId)
    }
}
