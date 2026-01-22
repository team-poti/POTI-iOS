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
        
        // TODO: - 서버 데이터로 변경하기
        
        let members = mockMembers.map {
            MemberEntity(id: $0.memberOptionId, name: $0.memberName, price: $0.memberOptionPrice)
        }
        
        let shippings = mockShippings.map {
            ShippingEntity(id: $0.deliveryOptionId, name: $0.deliveryName, price: $0.deliveryOptionPrice)
        }
        
        return PotOptionsEntity(members: members, shippings: shippings)
    }
    
    
    func fetchSaleDetail(postId: Int) async throws -> RecruitDetailEntity {
        let responseDTO = try await networkService.request(
            target: PostsAPI.fetchSaleDetail(postId: postId), type: RecruitDetailDTO.self
        )
        return responseDTO.toEntity()
    }
}
