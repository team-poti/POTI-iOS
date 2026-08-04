//
//  ArtistSearchUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

protocol ArtistSearchUseCase {
    func execute(keyword: String) async throws -> [ArtistSearchResultEntity]
}

final class DefaultArtistSearchUseCase: ArtistSearchUseCase {
    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(keyword: String) async throws -> [ArtistSearchResultEntity] {
        try await repository.searchArtists(keyword: keyword)
    }
}
