//
//  ParticipationsInterface.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

protocol ParticipationsInterface {
    func fetchMyParticipationsHistory(status: String) async throws -> MyPageParticipationsHistoryEntity
}
