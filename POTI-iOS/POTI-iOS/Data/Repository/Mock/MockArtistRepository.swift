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
        OnboardingArtistsEntity(
            artists: [
                makeArtist(id: 1, name: "IVE", imageSeed: "ive"),
                makeArtist(id: 2, name: "aespa", imageSeed: "aespa"),
                makeArtist(id: 3, name: "NewJeans", imageSeed: "newjeans"),
                makeArtist(id: 4, name: "LE SSERAFIM", imageSeed: "lesserafim"),
                makeArtist(id: 5, name: "NMIXX", imageSeed: "nmixx"),
                makeArtist(id: 6, name: "ITZY", imageSeed: "itzy"),
                makeArtist(id: 7, name: "TWICE", imageSeed: "twice"),
                makeArtist(id: 8, name: "BLACKPINK", imageSeed: "blackpink"),
                makeArtist(id: 9, name: "Red Velvet", imageSeed: "redvelvet"),
                makeArtist(id: 10, name: "(G)I-DLE", imageSeed: "gidle"),
                makeArtist(id: 11, name: "STAYC", imageSeed: "stayc"),
                makeArtist(id: 12, name: "KISS OF LIFE", imageSeed: "kissoflife"),
                makeArtist(id: 13, name: "BABYMONSTER", imageSeed: "babymonster"),
                makeArtist(id: 14, name: "ILLIT", imageSeed: "illit"),
                makeArtist(id: 15, name: "Hearts2Hearts", imageSeed: "hearts2hearts")
            ]
        )
    }

    private func makeArtist(id: Int, name: String, imageSeed: String) -> OnboardingArtistEntity {
        OnboardingArtistEntity(
            artistId: id,
            name: name,
            logoImageUrl: "https://picsum.photos/seed/\(imageSeed)/180/180"
        )
    }
}
