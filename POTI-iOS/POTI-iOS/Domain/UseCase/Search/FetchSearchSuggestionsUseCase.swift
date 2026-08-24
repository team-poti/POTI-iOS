//
//  FetchSearchSuggestionsUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

protocol FetchSearchSuggestionsUseCase {
    func execute(keyword: String) async throws -> [SearchSuggestionEntity]
}

final class DefaultFetchSearchSuggestionsUseCase: FetchSearchSuggestionsUseCase {
    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func execute(keyword: String) async throws -> [SearchSuggestionEntity] {
        return try await repository.fetchSuggestions(keyword: keyword)
    }
}
