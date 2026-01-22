//
//  DefaultPaymentsRepository.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

final class DefaultPaymentsRepository: PaymentsInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func patchPaymentConfirm(orderId: Int) async throws -> PaymentsConfirmDTO {
        let response = try await networkService.request(
            target: PaymentsAPI.patchPaymentConfirm(
                orderId: orderId),
            type: PaymentsConfirmDTO.self
        )
        return response
    }
}
