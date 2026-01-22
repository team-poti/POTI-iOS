//
//  DefaultPotDetailRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

final class DefaultPotDetailRepository: PotDetailInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPotDetail(postId: Int) async throws -> PotDetailEntity {
        let response: PotDetailDTO = try await networkService.request(
            target: PostsAPI.fetchPotDetail(postId: postId),
            type: PotDetailDTO.self
        )
        
        return response.toEntity()
    }
}
