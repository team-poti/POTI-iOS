//
//  JoinDetailViewState.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import UIKit

struct JoinDetailViewState {
    let potInfo: PotInfoViewState
    let progress: JoinProgressStatusViewCell.Model
    let myJoinDepositInfo: MyJoinDepositState
}

struct MyJoinDepositState {
    struct MemberRow: Equatable {
        let name: String
        let price: Int
    }
    
    let memberRows: [MemberRow]
    let shippingMethod: String
    let shippingFee: Int
    let totalAmount: Int
}

// MARK: - Mapper

struct JoinDetailViewStateMapper {
    private func resolveParticipantStatus(
        participants: [JoinDetailEntity]
    ) -> ParticipantStatus {
        
        // 참여자 기준: 대표 상태 (우선순위)
        if participants.contains(where: { $0.postStatus == .recruiting }) {
            return .recruiting
        }
        
        if participants.contains(where: { $0.paymentInfo.depositStatus == .waitPayCheck }) {
            return .waitPayCheck
        }
        
        return participants.first?.paymentInfo.depositStatus ?? .delivered
    }
    
    func map(entity: JoinDetailEntity) -> JoinDetailViewState {
        let potInfo = PotInfoViewState(
            postId: entity.postId,
            imageUrl: entity.imageUrl,
            artistName: entity.artistName,
            title: entity.title,
            statusMessage: entity.statusMessage
        )
        
        let participantStatus = entity.paymentInfo.depositStatus
        
        let progress = JoinProgressStatusViewCell.Model(
            postStatus: entity.postStatus,
            role: .participant,
            participantStatus: participantStatus
        )
        
        let myJoinDepositInfo = MyJoinDepositState(
            memberRows: entity.memberPayments.map { .init(name: $0.memberName, price: $0.price) },
            shippingMethod: entity.shippingInfo.shippingMethod,
            shippingFee: entity.paymentInfo.shippingFee,
            totalAmount: entity.paymentInfo.totalAmount
        )
        
        return JoinDetailViewState(
            potInfo: potInfo,
            progress: progress,
            myJoinDepositInfo: myJoinDepositInfo
        )
    }
}
