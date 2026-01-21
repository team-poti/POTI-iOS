//
//  OrderResponseDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

struct OrderParticipationDTO: Decodable {
    let participationId: Int
}

extension OrderParticipationDTO {
    func toEntity() -> OrderResultEntity {
        return .init(participationId: participationId)
    }
}
