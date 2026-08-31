//
//  JoinDetailScreenStateTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

final class JoinDetailScreenStateTests: XCTestCase {
    func testDepositInfoHeightMatchesFigmaSpacingForMemberRows() {
        let singleMember = MyJoinDepositState(
            memberRows: [.init(name: "안유진", price: 10)],
            shippingMethod: "준등기",
            shippingFee: 1800,
            totalAmount: 4010
        )
        let threeMembers = MyJoinDepositState(
            memberRows: [
                .init(name: "안유진", price: 10),
                .init(name: "장원영", price: 10),
                .init(name: "레이", price: 10)
            ],
            shippingMethod: "준등기",
            shippingFee: 1800,
            totalAmount: 4030
        )

        XCTAssertEqual(singleMember.contentHeight, 155)
        XCTAssertEqual(threeMembers.contentHeight, 213)
    }

    func testEveryParticipantStageMatchesDesignCopyAndAction() {
        let cases: [(PostStatus, ParticipantOrderStatus, String?, JoinDetailContentKind, JoinDetailBottomAction?)] = [
            (.recruiting, .waitPay, "다른 참여자들을 기다리고 있어요", .recruiting, nil),
            (.closed, .waitPay, "지금 입금해주세요!", .recruitCompleted, .submitDeposit),
            (.closed, .waitPayCheck, "모집자가 입금 내역을 확인하고 있어요", .recruitCompleted, nil),
            (.paymentDone, .paid, "모집자가 배송을 준비 중이에요", .depositCompleted, nil),
            (.shipping, .paid, "모집자가 배송을 시작했어요", .shipping, .completeDelivery),
            (.delivered, .paid, nil, .depositCompleted, nil)
        ]

        for (postStatus, participantStatus, message, contentKind, action) in cases {
            let state = JoinDetailScreenStateFactory.make(
                postStatus: postStatus,
                participantStatus: participantStatus
            )

            XCTAssertEqual(state.message, message)
            XCTAssertEqual(state.contentKind, contentKind)
            XCTAssertEqual(state.bottomAction, action)
            XCTAssertNotNil(state.progressImage)
        }
    }

    func testUnknownStatusIsPreservedAsSafeState() {
        let state = JoinDetailScreenStateFactory.make(
            postStatus: .closed,
            participantStatus: .unknown
        )

        XCTAssertEqual(state.message, "참여 상태를 확인해주세요")
        XCTAssertNil(state.bottomAction)
        XCTAssertNil(state.progressImage)
    }

    func testUnknownParticipantStatusHidesDeliveryActionWhilePostIsShipping() {
        let state = JoinDetailScreenStateFactory.make(
            postStatus: .shipping,
            participantStatus: .unknown
        )

        XCTAssertEqual(state.message, "참여 상태를 확인해주세요")
        XCTAssertNil(state.bottomAction)
        XCTAssertNil(state.progressImage)
    }

    func testMapperKeepsOrderNumberAndServerMessage() {
        let state = JoinDetailViewStateMapper().map(entity: makeEntity(statusMessage: " 서버 메시지 "))

        XCTAssertEqual(state.potInfo.postId, 182)
        XCTAssertEqual(state.potInfo.orderNumber, "ORDER-182")
        XCTAssertEqual(state.progress.message, "서버 메시지")
        XCTAssertEqual(state.myJoinDepositInfo.memberRows, [.init(name: "민지", price: 5_000)])
    }

    func testDeliveredStateHidesServerMessageToMatchFigma() {
        let entity = makeEntity(
            postStatus: .delivered,
            depositStatus: .delivered,
            statusMessage: "거래가 종료되었어요!"
        )

        let state = JoinDetailViewStateMapper().map(entity: entity)

        XCTAssertNil(state.progress.message)
    }

    private func makeEntity(
        postStatus: PostStatus = .closed,
        depositStatus: ParticipantOrderStatus = .waitPay,
        statusMessage: String
    ) -> JoinDetailEntity {
        JoinDetailEntity(
            participationId: 193,
            postId: 182,
            orderNumber: "ORDER-182",
            imageUrl: "",
            artistName: "POTI",
            title: "참여 상세",
            postStatus: postStatus,
            statusMessage: statusMessage,
            memberPayments: [.init(memberName: "민지", price: 5_000)],
            paymentInfo: .init(
                shippingFee: 1_800,
                totalAmount: 6_800,
                depositStatus: depositStatus,
                bank: "포티은행",
                accountNumber: "123-456",
                depositDeadline: "2026-08-30"
            ),
            shippingInfo: .init(
                shippingMethod: "준등기",
                receiver: "네온",
                zipcode: "06000",
                address: "서울시 포티구",
                phone: "010-0000-0000",
                carrier: "",
                trackingNumber: "",
                shippingStatus: .waitPay
            )
        )
    }
}
