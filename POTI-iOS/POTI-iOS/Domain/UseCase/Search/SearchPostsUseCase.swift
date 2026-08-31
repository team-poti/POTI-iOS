//
//  SearchPostsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

protocol SearchPostsUseCase {
    func execute(keyword: String, page: Int) async throws -> SearchResultPageEntity
}

final class DefaultSearchPostsUseCase: SearchPostsUseCase {
    private let repository: SearchInterface

    init(repository: SearchInterface) {
        self.repository = repository
    }

    func execute(keyword: String, page: Int) async throws -> SearchResultPageEntity {
        return try await repository.searchPosts(keyword: keyword, page: page)
    }
}
