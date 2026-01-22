//
//  RegisterPostUseCase.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

protocol RegisterTitlesUseCase {
    func execute(
        artistId: Int,
        keyword: String
    ) async throws -> [String?]
}

final class DefaultRegisterTitlesUseCase: RegisterTitlesUseCase {

    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(
        artistId: Int,
        keyword: String
    ) async throws -> [String?] {
        try await repository.fetchTitles(
            artistId: artistId,
            keyword: keyword
        )
    }
}
