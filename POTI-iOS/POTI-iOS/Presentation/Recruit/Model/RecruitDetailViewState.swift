//
//  RecruitDetailViewState.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import UIKit

struct RecruitDetailViewState {
    let potInfo: PotInfoViewState
    let progress: ProgressStatusViewCell.Model
    let participants: [ParticipantManageViewCell.Model]
}

struct PotInfoViewState {
    let postId: Int
    let imageUrl: String
    let artistName: String
    let title: String
    let status: PostStatus
}

struct ProgressViewState {
    let postStatus: PostStatus
    let role: UserRole
    let participantStatus: ParticipantStatus
    
    var statusText: String {
        switch postStatus {
            
        case .recruiting:
            return role == .host
            ? "참여자들을 기다리고 있어요"
            : "다른 참여자들을 기다리고 있어요"
            
        case .closed:
            switch participantStatus {
            case .recruiting:
                return "입금을 기다리는 중이에요"
            case .waitPayCheck:
                return "입금 확인을 기다리는 참여자가 있어요"
            default:
                return role == .host
                ? "입금 처리가 진행 중이에요"
                : "입금이 처리되고 있어요"
            }
            
        case .paymentDone:
            return role == .host
            ? "배송을 기다리는 참여자가 있어요"
            : "모집자가 배송을 준비 중이에요"
            
        case .shipping:
            return role == .host
            ? "배송을 시작했어요"
            : "모집자가 배송을 시작했어요"
            
        case .delivered:
            return "거래가 종료되었어요!"
        }
    }
}


// MARK: - Mapper

struct RecruitDetailViewStateMapper {
    private func resolveParticipantStatus(
        participants: [RecruitParticipantEntity]
    ) -> ParticipantStatus {

        // 모집자 기준: 대표 상태 (우선순위)
        if participants.contains(where: { $0.status == .recruiting }) {
            return .recruiting
        }

        if participants.contains(where: { $0.status == .waitPayCheck }) {
            return .waitPayCheck
        }

        return participants.first?.status ?? .delivered
    }
    
    func map(entity: RecruitDetailEntity) -> RecruitDetailViewState {
        let potInfo = PotInfoViewState(
            postId: entity.postId,
            imageUrl: entity.imageUrl,
            artistName: entity.artistName,
            title: entity.title,
            status: entity.postStatus
        )
        
        let participantStatus = resolveParticipantStatus(
            participants: entity.participant
        )
        
        let progress = ProgressStatusViewCell.Model(
            postStatus: entity.postStatus,
            role: .host,
            participantStatus: participantStatus
        )
        
        let participants: [ParticipantManageViewCell.Model] = entity.participant.map { participant in
            ParticipantManageViewCell.Model(
                memberNamesText: participant.memberNames,
                depositorNameText: participant.shippingInfo.receiverName,
                addressText: participant.shippingInfo.address,
                phoneText: participant.shippingInfo.phone,
                shippingText: participant.priceInfo.shippingName,
                totalPrice: participant.priceInfo.totalPrice,
                depositState: participant.status
            )
        }
        
        return RecruitDetailViewState(
            potInfo: potInfo,
            progress: progress,
            participants: participants
        )
    }
}
