//
//  DefaultArtistsRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

final class DefaultArtistsRepository: ArtistsInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchArtistsList(artistId: Int) async throws -> [ArtistsEntity] {
        let response: ArtistsDTO = try await networkService.request(
            target: ArtistsAPI.fetchArtistsList(artistId: artistId),
            type: ArtistsDTO.self
        )
        return response.members.map { $0.toEntity() }
    }
    
    func fetchOnboardingArtists() async throws -> OnboardingArtistsEntity {
        let result = try await networkService.request(
            target: ArtistsAPI.fetchOnboardingArtistsList,
            type: OnboardingArtistsResponseDTO.self
        )
        return result.toEntity()
    }
}
