//
//  SearchInterface.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

protocol SearchInterface {
    func searchPosts(keyword: String, page: Int) async throws -> SearchResultPageEntity
    func fetchSuggestions(keyword: String) async throws -> [SearchSuggestionEntity]
}
