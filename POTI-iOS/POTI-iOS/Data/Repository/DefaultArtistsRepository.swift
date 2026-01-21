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
        
        // TODO: - 서버 데이터 연결하기
        /*
        let artistsData = try await networkService.request(
            target: ArtistsAPI.fetchArtistsList(artistId: artistId),
            type: ArtistsResponseDTO.self
        )
        return artistsData.data.members.map { $0.toEntity() }
        */
        
        return [
            ArtistsEntity(artistId: 1, artistName: "원영"),
            ArtistsEntity(artistId: 2, artistName: "유진"),
            ArtistsEntity(artistId: 3, artistName: "가을"),
            ArtistsEntity(artistId: 4, artistName: "레이"),
            ArtistsEntity(artistId: 5, artistName: "리즈"),
            ArtistsEntity(artistId: 6, artistName: "이서")
        ]
    }
    
    func fetchOnboardingArtists() async throws -> OnboardingArtistsEntity {
        let result = try await networkService.request(
            target: ArtistsAPI.fetchOnboardingArtistsList,
            type: OnboardingArtistsResponseDTO.self
        )
        return result.toEntity()
    }
}
