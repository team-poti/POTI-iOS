//
//  ParticipantManagementStateTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

final class ParticipantManagementStateTests: XCTestCase {
    func testWaitingStatesHideDetailsAndActions() {
        for status in [ParticipantStatus.recruiting, .waitPay] {
            let state = ParticipantManagementStateFactory.make(status: status)

            XCTAssertFalse(state.isDetailVisible)
            XCTAssertNil(state.action)
            XCTAssertEqual(state.informationItems(for: makeModel(status: status)), [])
        }
    }

    func testWaitingForPaymentConfirmationShowsDepositInformationAndConfirmAction() {
        let state = ParticipantManagementStateFactory.make(status: .waitPayCheck)
        let items = state.informationItems(for: makeModel(status: .waitPayCheck))

        XCTAssertTrue(state.isDetailVisible)
        XCTAssertEqual(state.action, .confirmDeposit)
        XCTAssertEqual(
            items,
            [
                ParticipantInformationItem(
                    title: "입금 정보",
                    infos: ["네온", "2026-08-30 10:00"]
                )
            ]
        )
    }

    func testPaidStateShowsShippingInformationAndTrackingNumberAction() {
        let state = ParticipantManagementStateFactory.make(status: .paid)
        let items = state.informationItems(for: makeModel(status: .paid))

        XCTAssertTrue(state.isDetailVisible)
        XCTAssertEqual(state.action, .enterTrackingNumber)
        XCTAssertEqual(
            items,
            [
                ParticipantInformationItem(title: "이름", infos: ["네온"]),
                ParticipantInformationItem(title: "배송 정보", infos: ["서울시 포티구"]),
                ParticipantInformationItem(title: "연락처", infos: ["010-0000-0000"])
            ]
        )
    }

    func testTrackingStatesOnlyShowTrackingNumber() {
        for status in [ParticipantStatus.shipped, .delivered] {
            let state = ParticipantManagementStateFactory.make(status: status)

            XCTAssertTrue(state.isDetailVisible)
            XCTAssertNil(state.action)
            XCTAssertEqual(
                state.informationItems(for: makeModel(status: status)),
                [
                    ParticipantInformationItem(
                        title: "송장 번호",
                        infos: ["1234567890"]
                    )
                ]
            )
        }
    }

    func testEveryDomainStatusMapsToExpectedPresentationStatus() {
        let cases: [(ParticipantOrderStatus, ParticipantStatus)] = [
            (.waitPay, .waitPay),
            (.waitPayCheck, .waitPayCheck),
            (.paid, .paid),
            (.shipped, .shipped),
            (.delivered, .delivered),
            (.unknown, .waitPay)
        ]

        for (domain, presentation) in cases {
            XCTAssertEqual(ParticipantStatus(domainStatus: domain), presentation)
        }
    }

    private func makeModel(status: ParticipantStatus) -> ParticipantManageModel {
        ParticipantManageModel(
            purchaseId: 1,
            profileImage: "",
            nickname: "네온",
            memberTitle: ["멤버"],
            participantstatus: status,
            memberRows: [.init(name: "멤버", price: 5_000)],
            shippingText: "준등기",
            shippingPrice: 1_800,
            totalPrice: 6_800,
            waitPayCheckInfo: .init(
                depositorName: "네온",
                depositTimeText: "2026-08-30 10:00"
            ),
            paidInfo: .init(
                depositorName: "네온",
                depositTimeText: "2026-08-30 10:00"
            ),
            shipInfo: .init(
                receiverName: "네온",
                addressText: "서울시 포티구",
                phoneText: "010-0000-0000",
                trackingNumber: "1234567890"
            )
        )
    }
}
