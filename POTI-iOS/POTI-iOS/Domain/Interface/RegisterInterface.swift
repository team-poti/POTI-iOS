//
//  RegisterInterface.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

protocol RegisterInterface {
    func registerPosts(_ entity: RegisterRequestEntity) async throws -> RegisterResponseEntity
    func fetchTitles(artistId: Int, keyword: String) async throws -> [String?]
    func fetchArtists(keyword: String) async throws -> [RegisterArtistEntity]
}
