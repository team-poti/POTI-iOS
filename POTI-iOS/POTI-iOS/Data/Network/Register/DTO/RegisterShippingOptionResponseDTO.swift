//
//  RegisterShippingOptionResponseDTO.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

struct RegisterShippingOptionResponseDTO: Decodable {
    let deliveryId: Int
    let name: String
    let price: Int

    func toEntity() -> RegisterShippingOptionEntity {
        RegisterShippingOptionEntity(
            deliveryID: deliveryId,
            name: name,
            price: price
        )
    }
}
