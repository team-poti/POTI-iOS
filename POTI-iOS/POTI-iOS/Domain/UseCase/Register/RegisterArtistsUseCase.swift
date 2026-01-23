//
//  RegisterArtistsUseCase.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

protocol RegisterArtistsUseCase {
    func execute(keyword: String) async throws -> [RegisterArtistEntity]
}

final class DefaultRegisterArtistsUseCase: RegisterArtistsUseCase {
    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute(keyword: String) async throws -> [RegisterArtistEntity] {
        try await repository.fetchArtists(keyword: keyword)
    }
}
