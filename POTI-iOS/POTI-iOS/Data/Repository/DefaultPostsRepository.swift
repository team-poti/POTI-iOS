//
//  DefaultPostsRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

final class DefaultPostsRepository: PostsInterface {
    func fetchManagerData(postId: Int) async throws -> ManageEntity {
        let response = try await networkService.request(
            target: PostsAPI.fetchManage(postId: postId),
            type: ManageDTO.self
        )
        
        return response.toEntity()
    }
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchOrderOptions(postId: Int) async throws -> PotOptionsEntity {
        let response: PotOptionsDTO = try await networkService.request(
            target: PostsAPI.fetchPotOptions(postId: postId),
            type: PotOptionsDTO.self
        )
        
        return response.toEntity()
    }
    
    func fetchSaleDetail(postId: Int) async throws -> RecruitDetailEntity {
        let responseDTO = try await networkService.request(
            target: PostsAPI.fetchSaleDetail(postId: postId), type: RecruitDetailDTO.self
        )
        return responseDTO.toEntity()
    }
}
