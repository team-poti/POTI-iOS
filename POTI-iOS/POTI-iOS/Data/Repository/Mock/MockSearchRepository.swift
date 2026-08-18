//
//  MockSearchRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import Foundation

final class MockSearchRepository: SearchRepository {
    private let results: [SearchResultEntity]
    private let suggestions: [SearchSuggestionEntity]

    init(results: [SearchResultEntity]? = nil, suggestions: [SearchSuggestionEntity]? = nil) {
        self.results = results ?? MockSearchRepository.defaultResults
        self.suggestions = suggestions ?? MockSearchRepository.defaultSuggestions
    }

    func searchPosts(keyword: String, page: Int) async throws -> SearchResultPageEntity {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty, page >= 0 else {
            return SearchResultPageEntity(results: [], currentPage: page, hasNext: false)
        }

        let filteredResults = results.filter {
            $0.artist.localizedCaseInsensitiveContains(trimmedKeyword)
                || $0.postTitle.localizedCaseInsensitiveContains(trimmedKeyword)
        }
        let startIndex = page * 10
        guard startIndex < filteredResults.count else {
            return SearchResultPageEntity(results: [], currentPage: page, hasNext: false)
        }

        let endIndex = min(startIndex + 10, filteredResults.count)
        let pageResults = Array(filteredResults[startIndex..<endIndex])
        return SearchResultPageEntity(results: pageResults, currentPage: page, hasNext: endIndex < filteredResults.count)
    }

    func fetchSuggestions(keyword: String) async throws -> [SearchSuggestionEntity] {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return [] }

        return suggestions
            .filter { $0.value.localizedCaseInsensitiveContains(trimmedKeyword) }
            .prefix(10)
            .map { $0 }
    }
}

private extension MockSearchRepository {
    static let defaultResults = [
        SearchResultEntity(
            artist: "아이브",
            artistId: 1,
            postImage: "https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2025%2F7%2F31%2F7423083%2Fhigh.jpg&w=1920&q=75",
            postTitle: "아이브 포카 분철",
            postCount: 32,
            tag: "인기"
        ),
        SearchResultEntity(
            artist: "아이브",
            artistId: 1,
            postImage: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg",
            postTitle: "아이브 앨범 분철",
            postCount: 50,
            tag: "인기"
        ),
        SearchResultEntity(artist: "아이브", artistId: 1, postImage: nil, postTitle: "아이브 MD 분철", postCount: 2, tag: nil),
        SearchResultEntity(
            artist: "NCT WISH",
            artistId: 2,
            postImage: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2025/03/25/45725324-2b02-4a0a-948a-c271179bfb9b.jpg",
            postTitle: "NCT WISH 포토카드 공구",
            postCount: 18,
            tag: nil
        )
    ]

    static let defaultSuggestions = [
        SearchSuggestionEntity(type: .artist, value: "아이브"),
        SearchSuggestionEntity(type: .title, value: "아이브 포카 분철"),
        SearchSuggestionEntity(type: .title, value: "아이브 앨범 분철"),
        SearchSuggestionEntity(type: .artist, value: "NCT WISH"),
        SearchSuggestionEntity(type: .title, value: "NCT WISH 포토카드 공구")
    ]
}
