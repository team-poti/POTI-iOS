//
//  DefaultOrderManagementRepository.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

final class DefaultOrderManagementRepository: OrderManagementInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func patchTrackingNumber(orderId: Int, entity: TrackingNumberRequestEntity) async throws -> TrackingNumberResponseEntity {
        let requestDTO = TrackingNumberRequestDTO(
            carrier: entity.carrier,
            trackingNumber: entity.trackingNumber
        )
        let responseDTO = try await networkService.request(
            target: OrderManagementAPI.patchTrackingNumber(orderId: orderId, request: requestDTO),
            type: TrackingNumberResponseDTO.self
        )
        return responseDTO.toEntity()
    }

    func fetchManagerData(postId: Int) async throws -> ManageEntity {
        let response = try await networkService.request(
            target: OrderManagementAPI.fetchManage(postId: postId),
            type: ManageDTO.self
        )
        return response.toEntity()
    }

    func fetchSaleDetail(postId: Int) async throws -> RecruitDetailEntity {
        let responseDTO = try await networkService.request(
            target: OrderManagementAPI.fetchSaleDetail(postId: postId),
            type: RecruitDetailDTO.self
        )
        return responseDTO.toEntity()
    }
}
