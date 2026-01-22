//
//  ParticipationsInterface.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ParticipationsInterface {
    func fetchParticipationsDetail(participationId: Int) async throws -> JoinDetailEntity
}
