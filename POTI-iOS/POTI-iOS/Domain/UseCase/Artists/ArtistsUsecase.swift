//
//  ArtistsUsecase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

protocol ArtistsUsecase {
    func execute(artistId: Int) async throws -> [ArtistsEntity]
}

final class DefaultArtistsUseCase: ArtistsUsecase {
    private let repository: ArtistsInterface
    
    init(repository: ArtistsInterface) {
        self.repository = repository
    }
    
    func execute(artistId: Int) async throws -> [ArtistsEntity] {
        return try await repository.fetchArtistsList(artistId: artistId)
    }
}
