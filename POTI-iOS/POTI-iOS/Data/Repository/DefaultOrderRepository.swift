//
//  DefaultOrderRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

final class DefaultOrderRepository: OrderInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func submitOrder(entity: OrderRequestEntity) async throws -> OrderResultEntity {
//        let requestDTO = OrderRequestDTO(
//            groupBuyPostId: entity.postId,
//            shippingId: entity.shippingId,
//            deliveryInfo: .init(
//                receiverName: entity.receiverName,
//                zipcode: entity.zipcode,
//                addressLine: entity.addressLine,
//                phone: entity.phone
//            ),
//            items: entity.items.map { .init(groupBuyOptionId: $0.optionId, count: $0.count) }
//        )
        
//        let responseDTO = try await networkService.request(
//            target: OrdersAPI.submitOrder(request: requestDTO),
//            type: OrderParticipationDTO.self
//        )
//        
//        return responseDTO.toEntity()
        
        return OrderResultEntity(participationId: 1)
    }
}
