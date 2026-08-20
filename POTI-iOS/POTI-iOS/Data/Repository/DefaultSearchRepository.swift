//
//  DefaultSearchRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

final class DefaultSearchRepository: SearchRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func searchPosts(keyword: String, page: Int) async throws -> SearchResultPageEntity {
        let response: SearchResponseDTO = try await networkService.request(
            target: SearchAPI.searchPosts(keyword: keyword, page: page),
            type: SearchResponseDTO.self
        )
        return response.toEntity(currentPage: page)
    }

    func fetchSuggestions(keyword: String) async throws -> [SearchSuggestionEntity] {
        let response: SearchSuggestionResponseDTO = try await networkService.request(
            target: SearchAPI.fetchSuggestions(keyword: keyword),
            type: SearchSuggestionResponseDTO.self
        )
        return response.toEntity()
    }
}
