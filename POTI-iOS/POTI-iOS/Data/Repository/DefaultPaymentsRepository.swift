//
//  DefaultPaymentsRepository.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

final class DefaultPaymentsRepository: PaymentsInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func patchPaymentConfirm(orderId: Int) async throws -> RecruitPaymentsConfirmDTO {
        let response = try await networkService.request(
            target: PaymentsAPI.patchPaymentConfirm(
                orderId: orderId),
            type: RecruitPaymentsConfirmDTO.self
        )
        return response
    }
    
    func postPaymentConfirm(entity: PostPaymentEntity) async throws -> PostPaymentResponseEntity {
        let requestDTO = PostPaymentRequestDTO(
            participationId: entity.participationId,
            depositorName: entity.depositorName,
            depositedAt: entity.depositedAt
        )
        
        let response = try await networkService.request(
            target: PaymentsAPI.postPayment(request: requestDTO),
            type: PostPaymentResponseDTO.self
        )
        return response.toPostPaymentResponseEntity()
    }
}
