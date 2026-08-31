//
//  PotOrderViewModelTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/31/26.
//

import Combine
import XCTest
@testable import POTI_iOS

final class PotOrderViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testSelectedAddressMapsToSeparateRequestFields() {
        let useCase = MockApplyParticipationUseCase()
        let viewModel = makeViewModel(useCase: useCase)
        let completed = expectation(description: "order completed")

        viewModel.output.orderCompleted
            .sink { completed.fulfill() }
            .store(in: &cancellables)

        fillRequiredFields(in: viewModel)
        viewModel.action(.joinButtonDidTap)

        wait(for: [completed], timeout: 1)
        XCTAssertEqual(useCase.receivedEntity?.zipcode, "06000")
        XCTAssertEqual(useCase.receivedEntity?.address, "서울시 포티구")
        XCTAssertEqual(useCase.receivedEntity?.addressDetail, "193호")
    }

    func testServerAddressErrorIsDisplayedOnAddressField() {
        let useCase = MockApplyParticipationUseCase(error: PotiError.apiError(message: "주소를 입력해주세요."))
        let viewModel = makeViewModel(useCase: useCase)
        let failed = expectation(description: "order failed")
        var receivedMessage: String?

        viewModel.output.addressError
            .compactMap { $0 }
            .sink {
                receivedMessage = $0
                failed.fulfill()
            }
            .store(in: &cancellables)

        fillRequiredFields(in: viewModel)
        viewModel.action(.joinButtonDidTap)

        wait(for: [failed], timeout: 1)
        XCTAssertEqual(receivedMessage, "주소를 입력해주세요.")
    }

    private func makeViewModel(useCase: ApplyParticipationUseCase) -> PotOrderViewModel {
        PotOrderViewModel(
            useCase: useCase,
            postId: 182,
            shippingId: 3,
            orderItems: [.init(optionId: 7, count: 1)],
            shippingInfo: ("준등기", 1_800),
            memberInfos: [("멤버", 5_000)],
            uploaderNickname: "모집자"
        )
    }

    private func fillRequiredFields(in viewModel: PotOrderViewModel) {
        viewModel.action(.nameDidChange("네온"))
        viewModel.action(.addressSelected(zipcode: "06000", address: "서울시 포티구"))
        viewModel.action(.detailAddressDidChange("193호"))
        viewModel.action(.phoneDidChange("010-0000-0000"))
    }
}

private final class MockApplyParticipationUseCase: ApplyParticipationUseCase {
    private let error: Error?
    private(set) var receivedEntity: ParticipationEntity?

    init(error: Error? = nil) {
        self.error = error
    }

    func execute(info: ParticipationEntity) async throws -> ParticipationResponseEntity {
        receivedEntity = info
        if let error { throw error }
        return ParticipationResponseEntity(participationId: 193)
    }
}
