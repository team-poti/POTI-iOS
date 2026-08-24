//
//  RecruitDetailViewState.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

import UIKit

struct RecruitDetailViewState {
    let navigationTitle: String
    let potInfo: PotInfoViewState
    let progress: ProgressStatusViewCell.Model
    let participantCount: Int
    let participants: [ParticipantManageViewCell.Model]
}

struct PotInfoViewState {
    let postId: Int
    let orderNumber: String
    let imageUrl: String
    let artistName: String
    let title: String
    let status: PostStatus

    init(
        postId: Int,
        orderNumber: String = "",
        imageUrl: String,
        artistName: String,
        title: String,
        status: PostStatus
    ) {
        self.postId = postId
        self.orderNumber = orderNumber
        self.imageUrl = imageUrl
        self.artistName = artistName
        self.title = title
        self.status = status
    }
}

private protocol RecruitProgressState {
    var navigationTitle: String { get }
    var defaultMessage: String { get }
    var progressImage: UIImage? { get }
}

private struct RecruitingProgressState: RecruitProgressState {
    let navigationTitle = "진행 중인 분철"
    let defaultMessage = "참여자들을 기다리고 있어요"
    let progressImage: UIImage? = .imgStep0
}

private struct DepositWaitingProgressState: RecruitProgressState {
    let participantStatus: ParticipantStatus
    let navigationTitle = "진행 중인 분철"
    let progressImage: UIImage? = .imgStep1

    var defaultMessage: String {
        participantStatus == .waitPayCheck
        ? "입금 확인을 기다리는 참여자가 있어요"
        : "입금을 기다리는 중이에요"
    }
}

private struct PaymentCompletedProgressState: RecruitProgressState {
    let navigationTitle = "진행 중인 분철"
    let defaultMessage = "배송을 기다리는 참여자가 있어요"
    let progressImage: UIImage? = .imgStep2
}

private struct ShippingProgressState: RecruitProgressState {
    let navigationTitle = "진행 중인 분철"
    let defaultMessage = "배송을 시작했어요"
    let progressImage: UIImage? = .imgStep3
}

private struct DeliveredProgressState: RecruitProgressState {
    let navigationTitle = "종료된 분철"
    let defaultMessage = "거래가 종료되었어요"
    let progressImage: UIImage? = .imgStep4
}

private enum RecruitProgressStateFactory {
    static func make(
        postStatus: PostStatus,
        participantStatus: ParticipantStatus
    ) -> any RecruitProgressState {
        switch postStatus {
        case .recruiting:
            return RecruitingProgressState()
        case .closed:
            return DepositWaitingProgressState(participantStatus: participantStatus)
        case .paymentDone:
            return PaymentCompletedProgressState()
        case .shipping:
            return ShippingProgressState()
        case .delivered:
            return DeliveredProgressState()
        }
    }
}


// MARK: - Mapper

struct RecruitDetailViewStateMapper {
    private func resolveParticipantStatus(
        participants: [RecruitParticipantEntity]
    ) -> ParticipantStatus {

        if participants.contains(where: { $0.status == .waitPayCheck }) {
            return .waitPayCheck
        }

        if participants.contains(where: { $0.status == .waitPay }) {
            return .waitPay
        }

        if participants.contains(where: { $0.status == .paid }) {
            return .paid
        }

        if participants.contains(where: { $0.status == .shipped }) {
            return .shipped
        }

        return participants.first?.status ?? .recruiting
    }
    
    func map(entity: RecruitDetailEntity) -> RecruitDetailViewState {
        let potInfo = PotInfoViewState(
            postId: entity.postId,
            orderNumber: entity.orderNumber,
            imageUrl: entity.imageUrl,
            artistName: entity.artistName,
            title: entity.title,
            status: entity.postStatus
        )

        let participantStatus = resolveParticipantStatus(
            participants: entity.participant
        )

        let progressState = RecruitProgressStateFactory.make(
            postStatus: entity.postStatus,
            participantStatus: participantStatus
        )

        let serverMessage = entity.statusMessage.trimmingCharacters(in: .whitespacesAndNewlines)

        let progress = ProgressStatusViewCell.Model(
            message: serverMessage.isEmpty ? progressState.defaultMessage : serverMessage,
            progressImage: progressState.progressImage
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
            navigationTitle: progressState.navigationTitle,
            potInfo: potInfo,
            progress: progress,
            participantCount: entity.totalCount,
            participants: participants
        )
    }
}
