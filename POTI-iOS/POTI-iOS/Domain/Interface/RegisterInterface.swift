//
//  RegisterInterface.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

protocol RegisterInterface {
    func registerPost(_ entity: RegisterPostEntity) async throws -> RegisterPostResultEntity
    func fetchProductTitles(artistId: Int, keyword: String) async throws -> [String]
    func searchArtists(keyword: String) async throws -> [ArtistSearchResultEntity]
    func fetchShippingOptions() async throws -> [RegisterShippingOptionEntity]
}
