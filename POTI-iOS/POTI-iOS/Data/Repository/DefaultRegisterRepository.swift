//
//  DefaultRegisterRepository.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

final class DefaultRegisterRepository: RegisterInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func registerPosts(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity {
        let dto = CreatePostRequestDTO(from: entity)

        let result = try await networkService.request(
            target: RegisterAPI.registerPosts(dto),
            type: CreatePostResponseDTO.self
        )
        return result.toEntity()
    }

    func fetchProductTitles(artistId: Int, keyword: String) async throws -> [String] {
        let result = try await networkService.request(
            target: RegisterAPI.fetchProductTitles(artistId: artistId, keyword: keyword),
            type: FetchProductTitlesResponseDTO.self
        )
        return result.titles
    }

    func searchArtists(keyword: String) async throws -> [ArtistSearchResultEntity] {
        let result = try await networkService.request(
            target: RegisterAPI.searchArtists(keyword: keyword),
            type: ArtistSearchResponseDTO.self
        )

        return result.toEntities()
    }
}
