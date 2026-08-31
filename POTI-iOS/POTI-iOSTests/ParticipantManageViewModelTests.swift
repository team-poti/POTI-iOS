//
//  ParticipantManageViewModelTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import Combine
import XCTest
@testable import POTI_iOS

final class ParticipantManageViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func testViewDidLoadFetchesParticipants() {
        let participants = PostsParticipantsUseCaseSpy()
        let viewModel = makeViewModel(participants: participants)
        let fetched = expectation(description: "participants fetched")

        viewModel.output.fetchData
            .sink { fetched.fulfill() }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)

        wait(for: [fetched], timeout: 1)
        XCTAssertEqual(participants.receivedPostIds, [182])
        XCTAssertEqual(viewModel.participants.count, 1)
    }

    func testConfirmDepositCallsPaymentAPIAndRefreshesParticipants() {
        let participants = PostsParticipantsUseCaseSpy()
        let payments = PaymentsConfirmUseCaseSpy()
        let viewModel = makeViewModel(
            participants: participants,
            payments: payments
        )
        let refreshed = expectation(description: "participants refreshed")

        viewModel.output.fetchData
            .sink { refreshed.fulfill() }
            .store(in: &cancellables)

        viewModel.action(.confirmDeposit(orderId: 42))

        wait(for: [refreshed], timeout: 1)
        XCTAssertEqual(payments.receivedOrderIds, [42])
        XCTAssertEqual(participants.receivedPostIds, [182])
    }

    func testPatchTrackingNumberCallsDeliveryAPIRefreshesAndSignalsCompletion() {
        let participants = PostsParticipantsUseCaseSpy()
        let deliveries = OrdersDeliveriesUseCaseSpy()
        let viewModel = makeViewModel(
            participants: participants,
            deliveries: deliveries
        )
        let completed = expectation(description: "tracking number patched")

        viewModel.output.trackingNumberPatched
            .sink { completed.fulfill() }
            .store(in: &cancellables)

        viewModel.action(
            .patchTrackingNumber(
                orderId: 42,
                carrier: "우체국",
                trackingNumber: "1234567890"
            )
        )

        wait(for: [completed], timeout: 1)
        XCTAssertEqual(deliveries.receivedOrderIds, [42])
        XCTAssertEqual(deliveries.receivedEntities.first?.carrier, "우체국")
        XCTAssertEqual(
            deliveries.receivedEntities.first?.trackingNumber,
            "1234567890"
        )
        XCTAssertEqual(participants.receivedPostIds, [182])
    }

    private func makeViewModel(
        participants: PostsParticipantsUseCaseSpy = .init(),
        payments: PaymentsConfirmUseCaseSpy = .init(),
        deliveries: OrdersDeliveriesUseCaseSpy = .init()
    ) -> ParticipantManageViewModel {
        ParticipantManageViewModel(
            postId: 182,
            postsParticipantsUseCase: participants,
            paymentsUseCase: payments,
            ordersDeliveriesUseCase: deliveries
        )
    }
}

private final class PostsParticipantsUseCaseSpy: PostsParticipantsUseCase {
    private(set) var receivedPostIds: [Int] = []

    func execute(postId: Int) async throws -> ManageEntity {
        receivedPostIds.append(postId)
        return ManageEntity(
            participants: [
                ManageParticipantEntity(
                    orderId: 42,
                    userId: 7,
                    profileImage: nil,
                    nickname: "neon",
                    memberNames: ["멤버"],
                    status: .waitPay,
                    priceInfo: PriceInfoEntity(
                        memberPerPrices: [],
                        shippingName: "준등기",
                        shippingPrice: 1_800,
                        totalPrice: 1_800
                    ),
                    depositInfo: nil,
                    shippingInfo: nil
                )
            ]
        )
    }
}

private final class PaymentsConfirmUseCaseSpy: PaymentsConfirmUseCase {
    private(set) var receivedOrderIds: [Int] = []

    func execute(orderId: Int) async throws -> PaymentsConfirmEntity {
        receivedOrderIds.append(orderId)
        return PaymentsConfirmEntity(
            orderId: orderId,
            status: "PAID",
            confirmedAt: "2026-08-30T10:00:00"
        )
    }
}

private final class OrdersDeliveriesUseCaseSpy: OrdersDeliveriesUseCase {
    private(set) var receivedOrderIds: [Int] = []
    private(set) var receivedEntities: [TrackingNumberRequestEntity] = []

    func execute(
        orderId: Int,
        entity: TrackingNumberRequestEntity
    ) async throws -> TrackingNumberResponseEntity {
        receivedOrderIds.append(orderId)
        receivedEntities.append(entity)
        return TrackingNumberResponseEntity(
            orderId: orderId,
            status: "SHIPPED",
            trackingNumber: entity.trackingNumber,
            shippedAt: "2026-08-30T10:00:00"
        )
    }
}
