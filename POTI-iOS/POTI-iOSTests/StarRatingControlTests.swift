//
//  StarRatingControlTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

@MainActor
final class StarRatingControlTests: XCTestCase {
    func testInitialAccessibilityValueRepresentsZeroRating() {
        let control = StarRatingControl()

        XCTAssertEqual(control.accessibilityValue, "5점 중 0점")
    }

    func testRatingIsClampedToSupportedRange() {
        let control = StarRatingControl()

        control.setRating(8)
        XCTAssertEqual(control.rating, 5)

        control.setRating(-1)
        XCTAssertEqual(control.rating, 0)
    }

    func testAccessibilityAdjustmentsChangeRating() {
        let control = StarRatingControl()

        control.accessibilityIncrement()
        XCTAssertEqual(control.rating, 1)
        XCTAssertEqual(control.accessibilityValue, "5점 중 1점")

        control.accessibilityDecrement()
        XCTAssertEqual(control.rating, 0)
    }

    func testWithdrawalUnavailableViewDoesNotAddDuplicateOverlay() {
        let hostView = UIView()

        WithdrawalUnavailableView().show(on: hostView)
        WithdrawalUnavailableView().show(on: hostView)

        XCTAssertEqual(hostView.subviews.compactMap { $0 as? WithdrawalUnavailableView }.count, 1)
    }

    func testReviewCompletionCanOnlyBeSubmittedOnce() throws {
        var completionCount = 0
        let popup = StarRatingPopupView(
            onCompleteButton: { _ in completionCount += 1 },
            onSkipButton: {}
        )
        let ratingControl = try XCTUnwrap(findSubview(of: StarRatingControl.self, in: popup))
        let confirmButton = try XCTUnwrap(
            popup.allSubviews
                .compactMap { $0 as? UIButton }
                .first { $0.title(for: .normal) == "완료" }
        )

        ratingControl.setRating(4, sendsEvent: true)
        confirmButton.sendActions(for: .touchUpInside)
        confirmButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(completionCount, 1)
        XCTAssertFalse(confirmButton.isEnabled)
    }

    private func findSubview<T: UIView>(of type: T.Type, in view: UIView) -> T? {
        if let matchingView = view as? T {
            return matchingView
        }
        return view.subviews.lazy.compactMap { self.findSubview(of: type, in: $0) }.first
    }
}

private extension UIView {
    var allSubviews: [UIView] {
        subviews + subviews.flatMap(\.allSubviews)
    }
}
