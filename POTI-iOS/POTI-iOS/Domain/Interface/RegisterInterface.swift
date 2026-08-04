//
//  RegisterInterface.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

protocol RegisterInterface {
    func registerPosts(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity
    func fetchProductTitles(artistId: Int, keyword: String) async throws -> [String]
    func searchArtists(keyword: String) async throws -> [ArtistSearchResultEntity]
}
