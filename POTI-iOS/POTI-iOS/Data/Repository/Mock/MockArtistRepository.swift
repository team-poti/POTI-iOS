//
//  MockArtistRepository.swift
//  POTI-iOS
//
//  Created by soomin on 6/8/26.
//

import Foundation

final class MockArtistRepository: ArtistsInterface {
    func fetchArtistMembers(artistId: Int) async throws -> [ArtistMemberEntity] {
        let totalMembers = [
            ArtistMemberEntity(memberId: 10, name: "장원영"),
            ArtistMemberEntity(memberId: 11, name: "안유진"),
            ArtistMemberEntity(memberId: 12, name: "레이"),
            ArtistMemberEntity(memberId: 13, name: "리즈"),
            ArtistMemberEntity(memberId: 14, name: "이서"),
            ArtistMemberEntity(memberId: 15, name: "가을"),
        ]
        
        if artistId == 1 {
            return totalMembers.filter { $0.memberId >= 10 && $0.memberId < 20 }
        } else if artistId == 2 {
            return totalMembers.filter { $0.memberId >= 20 && $0.memberId < 30 }
        } else {
            return [
                ArtistMemberEntity(memberId: 99, name: "테스트 멤버A"),
                ArtistMemberEntity(memberId: 100, name: "테스트 멤버B")
            ]
        }
    }
    
    func fetchOnboardingArtists() async throws -> OnboardingArtistsEntity {
        return OnboardingArtistsEntity(
            artists: []
        )
    }
}
