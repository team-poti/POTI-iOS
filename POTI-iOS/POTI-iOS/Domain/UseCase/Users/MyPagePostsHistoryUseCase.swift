//
//  MyPagePostsHistoryUseCase.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

protocol MyPagePostsHistoryUseCase {
    func execute(status: String) async throws -> MyPagePostsHistoryEntity
}

final class DefaultMyPagePostsHistoryUseCase: MyPagePostsHistoryUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(status: String) async throws -> MyPagePostsHistoryEntity {
        return try await repository.fetchMyPostsHistory(status: status)
    }
}
