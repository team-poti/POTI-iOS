//
//  ParticipationDeliverResponseDTO.swift
//  POTI-iOS
//
//  Created by Neon on 1/23/26.
//

struct ParticipationDeliverResponseDTO: Decodable {
    let leaderUserId: Int
}

extension ParticipationDeliverResponseDTO {
    func toEntity() -> ParticipationDeliveredEntity {
        return ParticipationDeliveredEntity(
            leaderUserId: leaderUserId
        )
    }
}
