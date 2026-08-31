//
//  ParticipantManagementState.swift
//  POTI-iOS
//
//  Created by Neon on 8/30/26.
//

struct ParticipantInformationItem: Equatable {
    let title: String
    let infos: [String]
}

enum ParticipantManagementAction: Equatable {
    case confirmDeposit
    case enterTrackingNumber

    var title: String {
        switch self {
        case .confirmDeposit:
            return "입금 확인"
        case .enterTrackingNumber:
            return "송장 번호 입력"
        }
    }
}

protocol ParticipantManagementState {
    var isDetailVisible: Bool { get }
    var action: ParticipantManagementAction? { get }
    func informationItems(for model: ParticipantManageModel) -> [ParticipantInformationItem]
}

struct WaitingParticipantState: ParticipantManagementState {
    let isDetailVisible = false
    let action: ParticipantManagementAction? = nil

    func informationItems(
        for model: ParticipantManageModel
    ) -> [ParticipantInformationItem] {
        []
    }
}

struct DepositCheckingParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let action: ParticipantManagementAction? = .confirmDeposit

    func informationItems(
        for model: ParticipantManageModel
    ) -> [ParticipantInformationItem] {
        [
            ParticipantInformationItem(
                title: "입금 정보",
                infos: [
                    model.waitPayCheckInfo?.depositorName ?? "",
                    model.waitPayCheckInfo?.depositTimeText ?? ""
                ]
            )
        ]
    }
}

struct PaidParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let action: ParticipantManagementAction? = .enterTrackingNumber

    func informationItems(
        for model: ParticipantManageModel
    ) -> [ParticipantInformationItem] {
        [
            ParticipantInformationItem(
                title: "이름",
                infos: [model.shipInfo?.receiverName ?? ""]
            ),
            ParticipantInformationItem(
                title: "배송 정보",
                infos: [model.shipInfo?.addressText ?? ""]
            ),
            ParticipantInformationItem(
                title: "연락처",
                infos: [model.shipInfo?.phoneText ?? ""]
            )
        ]
    }
}

struct TrackingParticipantState: ParticipantManagementState {
    let isDetailVisible = true
    let action: ParticipantManagementAction? = nil

    func informationItems(
        for model: ParticipantManageModel
    ) -> [ParticipantInformationItem] {
        [
            ParticipantInformationItem(
                title: "송장 번호",
                infos: [model.shipInfo?.trackingNumber ?? ""]
            )
        ]
    }
}

enum ParticipantManagementStateFactory {
    static func make(status: ParticipantStatus) -> any ParticipantManagementState {
        switch status {
        case .recruiting, .waitPay, .unknown:
            return WaitingParticipantState()
        case .waitPayCheck:
            return DepositCheckingParticipantState()
        case .paid:
            return PaidParticipantState()
        case .shipped, .delivered:
            return TrackingParticipantState()
        }
    }
}
