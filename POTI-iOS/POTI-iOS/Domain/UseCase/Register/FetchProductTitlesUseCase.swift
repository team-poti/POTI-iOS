//
//  FetchProductTitlesUseCase.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

protocol FetchProductTitlesUseCase {
    func execute(artistId: Int, keyword: String) async throws -> [String]
}

final class DefaultFetchProductTitlesUseCase: FetchProductTitlesUseCase {
    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(artistId: Int, keyword: String) async throws -> [String] {
        try await repository.fetchProductTitles(artistId: artistId, keyword: keyword)
    }
}
