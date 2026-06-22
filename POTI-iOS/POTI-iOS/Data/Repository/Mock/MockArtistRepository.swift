//
//  MockArtistRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 6/8/26.
//

import Foundation

final class MockArtistRepository: ArtistsInterface {
    func fetchArtistMembers(artistId: Int) async throws -> [ArtistsEntity] {
        let totalMembers = [
            ArtistsEntity(artistId: 10, artistName: "장원영"),
            ArtistsEntity(artistId: 11, artistName: "안유진"),
            ArtistsEntity(artistId: 12, artistName: "레이"),
            ArtistsEntity(artistId: 13, artistName: "리즈"),
            ArtistsEntity(artistId: 14, artistName: "이서"),
            ArtistsEntity(artistId: 15, artistName: "가을"),
        ]
        
        if artistId == 1 {
            return totalMembers.filter { $0.artistId >= 10 && $0.artistId < 20 }
        } else if artistId == 2 {
            return totalMembers.filter { $0.artistId >= 20 && $0.artistId < 30 }
        } else {
            return [
                ArtistsEntity(artistId: 99, artistName: "테스트 멤버A"),
                ArtistsEntity(artistId: 100, artistName: "테스트 멤버B")
            ]
        }
    }
    
    func fetchOnboardingArtists() async throws -> OnboardingArtistsEntity {
        return OnboardingArtistsEntity(
            artists: []
        )
    }
}
