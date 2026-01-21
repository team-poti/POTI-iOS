//
//  DefaultOrderRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

final class DefaultOrderRepository: OrderInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchOrderOptions() async throws -> OrderEntity {
        
        // TODO: - 서버 데이터로 변경하기
        
        let members = mockMembers.map {
            MemberEntity(id: $0.memberOptionId, name: $0.memberName, price: $0.memberOptionPrice)
        }
        
        let shippings = mockShippings.map {
            ShippingEntity(id: $0.deliveryOptionId, name: $0.deliveryName, price: $0.deliveryOptionPrice)
        }
        
        return OrderEntity(members: members, shippings: shippings)
    }
}
