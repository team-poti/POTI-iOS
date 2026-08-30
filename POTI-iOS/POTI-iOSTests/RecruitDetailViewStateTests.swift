//
//  RecruitDetailViewStateTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

final class RecruitDetailViewStateTests: XCTestCase {
    func testRecruitProgressMatchesEveryDesignStage() {
        let cases: [(PostStatus, ParticipantOrderStatus, String, String)] = [
            (.recruiting, .waitPay, "진행 중인 분철", "참여자들을 기다리고 있어요"),
            (.closed, .waitPay, "진행 중인 분철", "입금을 기다리는 중이에요"),
            (.closed, .waitPayCheck, "진행 중인 분철", "입금 확인을 기다리는 참여자가 있어요"),
            (.paymentDone, .paid, "진행 중인 분철", "배송을 기다리는 참여자가 있어요"),
            (.shipping, .shipped, "진행 중인 분철", "배송을 시작했어요"),
            (.delivered, .delivered, "종료된 분철", "거래가 종료되었어요")
        ]

        for (postStatus, participantStatus, navigationTitle, message) in cases {
            let state = makeState(postStatus: postStatus, participantStatuses: [participantStatus])

            XCTAssertEqual(state.navigationTitle, navigationTitle)
            XCTAssertEqual(state.progress.message, message)
            XCTAssertNotNil(state.progress.progressImage)
        }
    }

    func testDepositConfirmationHasPriorityInClosedRecruitment() {
        let state = makeState(
            postStatus: .closed,
            participantStatuses: [.paid, .waitPay, .waitPayCheck, .shipped]
        )

        XCTAssertEqual(state.progress.message, "입금 확인을 기다리는 참여자가 있어요")
    }

    func testServerStatusMessageOverridesDefaultMessage() {
        let state = makeState(
            postStatus: .shipping,
            participantStatuses: [.shipped],
            statusMessage: "  서버 진행 메시지  "
        )

        XCTAssertEqual(state.progress.message, "서버 진행 메시지")
    }

    func testUnknownParticipantStatusIsNotDisplayedAsPaymentWaiting() {
        let state = makeState(postStatus: .closed, participantStatuses: [.unknown])

        XCTAssertEqual(state.progress.message, "참여자 상태를 확인해주세요")
        XCTAssertEqual(state.participants.first?.depositState, .unknown)
    }

    func testParticipantDataMapsWithoutDroppingOrderInformation() throws {
        let state = makeState(postStatus: .closed, participantStatuses: [.waitPayCheck])
        let participant = try XCTUnwrap(state.participants.first)

        XCTAssertEqual(state.participantCount, 1)
        XCTAssertEqual(participant.memberNamesText, ["민지", "하니"])
        XCTAssertEqual(participant.depositorNameText, "네온")
        XCTAssertEqual(participant.addressText, "서울시 포티구")
        XCTAssertEqual(participant.phoneText, "010-0000-0000")
        XCTAssertEqual(participant.shippingText, "준등기")
        XCTAssertEqual(participant.totalPrice, 6_800)
        XCTAssertEqual(participant.depositState, .waitPayCheck)
    }

    private func makeState(
        postStatus: PostStatus,
        participantStatuses: [ParticipantOrderStatus],
        statusMessage: String = ""
    ) -> RecruitDetailViewState {
        let participants = participantStatuses.enumerated().map { index, status in
            RecruitParticipantEntity(
                orderId: index + 1,
                userId: index + 10,
                memberNames: ["민지", "하니"],
                status: status,
                priceInfo: .init(shippingName: "준등기", totalPrice: 6_800),
                shippingInfo: .init(
                    receiverName: "네온",
                    address: "서울시 포티구",
                    phone: "010-0000-0000"
                )
            )
        }

        let entity = RecruitDetailEntity(
            postId: 182,
            orderNumber: "ORDER-182",
            totalCount: participants.count,
            imageUrl: "",
            artistName: "POTI",
            title: "모집 상세",
            postStatus: postStatus,
            statusMessage: statusMessage,
            participant: participants
        )

        return RecruitDetailViewStateMapper().map(entity: entity)
    }
}
