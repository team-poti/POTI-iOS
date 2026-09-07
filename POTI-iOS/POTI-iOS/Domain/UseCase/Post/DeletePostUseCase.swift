//
//  DeletePostUseCase.swift
//  POTI-iOS
//

protocol DeletePostUseCase {
    func execute(postId: Int) async throws
}

final class DefaultDeletePostUseCase: DeletePostUseCase {
    private let repository: PostInterface

    init(repository: PostInterface) {
        self.repository = repository
    }

    func execute(postId: Int) async throws {
        try await repository.deletePost(postId: postId)
    }
}
