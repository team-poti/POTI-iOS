//
//  MemberInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

protocol ArtistsInterface {
    func fetchArtistsList(artistId: Int) async throws -> [ArtistsEntity]
    func fetchOnboardingArtists() async throws -> OnboardingArtistsEntity
}
