//
//  ArtistMembersUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

protocol ArtistMembersUseCase {
    func execute(artistId: Int) async throws -> [ArtistsEntity]
}

final class DefaultArtistsUseCase: ArtistMembersUseCase {
    private let repository: ArtistsInterface
    
    init(repository: ArtistsInterface) {
        self.repository = repository
    }
    
    func execute(artistId: Int) async throws -> [ArtistsEntity] {
        return try await repository.fetchArtistMembers(artistId: artistId)
    }
}
