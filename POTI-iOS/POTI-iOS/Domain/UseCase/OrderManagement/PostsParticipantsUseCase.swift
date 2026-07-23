//
//  PostsParticipantsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 6/11/26.
//

import Foundation

protocol PostsParticipantsUseCase {
    func execute(postId: Int) async throws -> ManageEntity
}

final class DefaultPostsParticipantsUseCase: PostsParticipantsUseCase {

    private let repository: OrderManagementInterface

    init(repository: OrderManagementInterface) {
        self.repository = repository
    }

    func execute(postId: Int) async throws -> ManageEntity {
        return try await repository.fetchManagerData(postId: postId)
    }
}
