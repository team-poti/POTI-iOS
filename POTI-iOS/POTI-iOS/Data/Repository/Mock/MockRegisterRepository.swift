//
//  MockRegisterRepository.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import Foundation

final class MockRegisterRepository: RegisterInterface {

    // MARK: - Properties

    private let registeredPostId: Int
    private let artists: [ArtistSearchResultEntity]
    private let productTitlesByArtistId: [Int: [String]]

    // MARK: - Initializer

    init(
        registeredPostId: Int = 1,
        artists: [ArtistSearchResultEntity] = [
            ArtistSearchResultEntity(artistId: 1, name: "IVE"),
            ArtistSearchResultEntity(artistId: 2, name: "NCT WISH"),
            ArtistSearchResultEntity(artistId: 3, name: "NCT 127"),
            ArtistSearchResultEntity(artistId: 4, name: "NEWJEANS")
        ],
        productTitlesByArtistId: [Int: [String]] = [
            1: [
                "아이브 정규 1집 공구",
                "아이브 포카 분철",
                "아이엠 스페셜 에디션"
            ],
            2: [
                "NCT WISH 앨범 분철",
                "NCT WISH 포토카드 공구"
            ],
            3: [
                "NCT 127 정규 앨범",
                "NCT 127 MD 분철"
            ],
            4: [
                "NEWJEANS 앨범 공구"
            ]
        ]
    ) {
        self.registeredPostId = registeredPostId
        self.artists = artists
        self.productTitlesByArtistId = productTitlesByArtistId
    }

    func registerPost(_ entity: RegisterPostEntity) async throws -> RegisterPostResultEntity {
        RegisterPostResultEntity(postId: registeredPostId)
    }

    func fetchProductTitles(artistId: Int, keyword: String) async throws -> [String] {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return [] }

        return productTitlesByArtistId[artistId, default: []]
            .filter { $0.localizedCaseInsensitiveContains(trimmedKeyword) }
            .prefix(5)
            .map { $0 }
    }

    func searchArtists(keyword: String) async throws -> [ArtistSearchResultEntity] {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return [] }

        return artists.filter {
            $0.name.localizedCaseInsensitiveContains(trimmedKeyword)
        }
    }
}
