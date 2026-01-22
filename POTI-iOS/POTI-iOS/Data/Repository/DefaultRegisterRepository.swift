//
//  DefaultRegisterRepository.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

final class DefaultRegisterRepository: RegisterInterface {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func registerPosts(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity {
        let dto = RegisterRequestDTO(from: entity)

        let result = try await networkService.request(
            target: RegisterAPI.registerPosts(dto),
            type: RegisterResponseDTO.self
        )

        return result.toEntity()
    }

    func fetchTitles(artistId: Int64, keyword: String) async throws -> [String] {
        let result = try await networkService.request(
            target: RegisterAPI.fetchTitles(artistId: artistId, keyword: keyword),
            type: RegisterTitlesResponseDTO.self
        )
        return result.toEntities()
    }

    func fetchArtists(keyword: String) async throws -> [RegisterArtistEntity] {
        let result = try await networkService.request(
            target: RegisterAPI.fetchArtists(keyword: keyword),
            type: RegisterArtistsResponseDTO.self
        )

        return result.toEntities()
    }
}
